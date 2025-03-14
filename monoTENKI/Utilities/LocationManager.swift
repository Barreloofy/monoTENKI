//
//  LocationManager.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/6/25 at 6:59 PM.
//

import Foundation
import CoreLocation
import os

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let queue = DispatchQueue(label: "com.monoTENKI.LocationManagerSerial")
    nonisolated(unsafe) static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var _trackLocation = UserDefaults.standard.bool(forKey: "tracklocation") {
        didSet {
            UserDefaults.standard.set(_trackLocation, forKey: "tracklocation")
        }
    }
    @Published var currentLocation: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 1000
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }
    
    var trackLocation: Bool {
        get {
            queue.sync {
                return _trackLocation
            }
        }
        
        set {
            queue.sync {
                _trackLocation = newValue
            }
        }
    }
    
    var stringLocation: String {
        queue.sync {
            guard let latitude = currentLocation?.latitude,
                 let longitude = currentLocation?.longitude else { return "" }
            
            return "\(latitude) \(longitude)"
        }
    }
}

extension LocationManager {
    func requestAuthorization() {
        queue.sync {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        queue.sync {
            guard let currentLocation = locations.last?.coordinate else { return }
            self.currentLocation = currentLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        queue.sync {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
    }
}

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude != rhs.latitude && lhs.longitude != rhs.longitude ? false : true
    }
}
