//
//  LocationManager.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/6/25 at 6:59 PM.
//

import Foundation
import CoreLocation
import OSLog

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let queue = DispatchQueue(label: "com.monoTENKI.LocationManagerSerial")
    nonisolated(unsafe) static let shared = LocationManager()
    
    let locationLogger = Logger(subsystem: "com.monoTENKI.location", category: "Error")
    
    private let locationManager = CLLocationManager()
    private var _trackLocation = false
    @Published var currentLocation: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 1000
    }
    
    var trackLocation: Bool {
        get {
            queue.sync {
                return _trackLocation
            }
        }
        set {
            queue.sync {
                LocationManager.shared._trackLocation = newValue
            }
        }
    }
    
    var stringLocation: String? {
        queue.sync {
            guard let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude else { return nil }
            return "\(latitude) \(longitude)"
        }
    }
    
    func requestAuthorization() {
        queue.sync {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        queue.sync {
            guard let location = locations.last else { return }
            currentLocation = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        queue.sync {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                locationManager.startUpdatingLocation()
                _trackLocation = true
            }
        }
    }
}

extension LocationManager {
    enum LocationError: Error, LocalizedError {
        case managerError
        case locationNil
        
        var localizedDescription: String {
            switch self {
                case .managerError:
                    return "Error: member of LocationManager instance returned nil"
                case .locationNil:
                    return "Error: found unexpectedly nil in Array"
            }
        }
    }
}

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        if lhs.latitude != rhs.latitude && lhs.longitude != rhs.longitude {
            return false
        }
        return true
    }
}
