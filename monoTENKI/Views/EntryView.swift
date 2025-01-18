//
//  EntryView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/8/25 at 9:34 PM.
//

import SwiftUI

struct EntryView: View {
    @StateObject private var weatherData = WeatherData()
    @StateObject private var locationManager = LocationManager.shared
    @AppStorage("isfirstlaunch") private var isFirstLaunch = true
    @State private var isError = false
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if isFirstLaunch {
                SetUpView()
            } else if isError {
                ErrorView(isError: $isError)
            } else if isLoading {
                Color(.black).ignoresSafeArea()
            } else {
                WeatherView()
            }
        }
        .onAppear {
            print(locationManager.trackLocation)
        }
        .onChange(of: weatherData.currentLocation, initial: true) {
            weatherData.fetchWeather() { result in
                switch result {
                    case .success():
                        isLoading = false
                    case .failure(_):
                        isError = true
                }
            }
        }
        .onChange(of: locationManager.currentLocation) {
            updateWeatherToLocation()
        }
        .environmentObject(weatherData)
    }
    
    private func updateWeatherToLocation() {
        guard locationManager.trackLocation else { return }
        Task {
            do {
                guard let newCoordinates = locationManager.stringLocation else { throw LocationManager.LocationError.managerError
                }
                guard let newLocation = try await APIClient.fetch(service: .location, forType: [Location].self, newCoordinates).first else {
                    throw LocationManager.LocationError.locationNil
                }
                weatherData.currentLocation = newLocation.name
            } catch {
                locationManager.locationLogger.error("\(error)")
                isError = true
            }
        }
    }
}

#Preview {
    EntryView()
        .environmentObject(UnitData())
}
