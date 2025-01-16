//
//  SearchView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 5:28 PM.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var weatherData: WeatherData
    @Environment(\.dismiss) private var dismiss
    @FocusState private var textFieldIsFocused: Bool
    @State private var text = ""
    @State private var locations = [Location]()
    @State private var showAlert = false
    private var locationManager = LocationManager.shared
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Text("Location")
                    HStack {
                        Spacer()
                        Text("X")
                            .onTapGesture {
                                dismiss()
                            }
                    }
                }
                TextField("", text: $text)
                    .searchTextField(text, _textFieldIsFocused)
                    .focused($textFieldIsFocused)
                    .font(.system(.title, design: .rounded, weight: .bold))
                HStack {
                    Label("CURRENT LOCATION", systemImage: "location.fill")
                        .onTapGesture {
                            fetchCurrentLocation()
                        }
                    Spacer()
                }
                .font(.system(.title3, design: .serif, weight: .bold))
                ScrollView {
                    ForEach(locations) { location in
                        HStack {
                            Text(location.name)
                                .layoutPriority(1)
                            Text(location.country)
                            Spacer()
                        }
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .truncationMode(.tail)
                        .onTapGesture {
                            weatherData.currentLocation = location.name
                            locationManager.trackLocation = false
                            dismiss()
                        }
                    }
                }
            }
            .font(.system(.title, design: .serif, weight: .bold))
            .foregroundStyle(.white)
            .padding()
            .background(.black)
            .onChange(of: text) {
                fetchLocations()
            }
            .blur(radius: showAlert ? 5 : 0)
            if showAlert {
                AlertView(show: $showAlert, title: "UH, OH", message: "SOMETHING WENT WRONG", actionMessage: "TAP TO RETRY")
            }
        }
    }
    
    private func fetchLocations() {
        Task {
            do {
                guard !text.isEmpty else { return }
                locations = try await APIClient.fetch(service: .location, forType: [Location].self, text)
            } catch {
                showAlert = true
            }
        }
    }
    
    private func fetchCurrentLocation() {
        Task {
            do {
                guard let query = locationManager.stringLocation else { throw LocationManager.LocationError.managerError }
                let results = try await APIClient.fetch(service: .location, forType: [Location].self, query)
                guard let firstResult = results.first else { throw LocationManager.LocationError.locationNil }
                weatherData.currentLocation = firstResult.name
                locationManager.trackLocation = true
                dismiss()
            } catch {
                showAlert = true
            }
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(WeatherData())
}
