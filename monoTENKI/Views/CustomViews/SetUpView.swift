//
//  SetUpView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/8/25 at 2:57 PM.
//

import SwiftUI
import OSLog

fileprivate let setUpLogger = Logger(subsystem: "com.monoTENKI.SetUp", category: "Error")


struct SetUpView: View {
    @EnvironmentObject private var unitData: UnitData
    @EnvironmentObject private var weatherData: WeatherData
    @ObservedObject var locationManager: LocationManager = LocationManager.shared
    @AppStorage("isfirstlaunch") var isFirstLaunch: Bool = true
    @State private var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            GuideView {
                Text("Greetings fellow weather watcher! first let's setup a few things before occupying ourselves with the more interesting things in life The Weather!")
            } content: {
                Button {
                    selection += 1
                } label: {
                    Text("Get started")
                }
                .buttonStyle(.monoBordered)
            }
            .tag(0)
            
            GuideView {
                Text("Grant localtion access to\n get the most accurate weather\n")
            } content: {
                Button {
                    locationManager.requestAuthorization()
                } label: {
                    Text("Grand permission")
                }
                .buttonStyle(.monoBordered)
                Button {
                    selection += 1
                } label: {
                    Text("No, thank you!")
                }
                .buttonStyle(.monoBordered)
                .onChange(of: locationManager.currentLocation) {
                    setToCurrentLocation()
                }
            }
            .tag(1)
            
            SetUpSearchView(selection: $selection)
                .tag(2)
            
            GuideView {
                Text("One more thing, please choose\n your preferred weather unit:\n")
            } content: {
                Button {
                    unitData.temperature = .celsius
                    unitData.speed = .kilometersPerHour
                    unitData.measurement = .millimeter
                    isFirstLaunch = false
                } label: {
                    Text("Metric")
                }
                .buttonStyle(.monoBordered)
                Button {
                    unitData.temperature = .fahrenheit
                    unitData.speed = .milesPerHour
                    unitData.measurement = .inch
                    isFirstLaunch = false
                } label: {
                    Text("Imperial")
                }
                .buttonStyle(.monoBordered)
            }
            .tag(3)
        }
    }
    
    private func setToCurrentLocation() {
        Task {
            do {
                guard let query = locationManager.stringLocation else { throw LocationManager.LocationError.managerError }
                let results = try await APIClient.fetch(service: .location, forType: [Location].self, query)
                guard let firstResult = results.first else { throw LocationManager.LocationError.locationNil }
                weatherData.currentLocation = firstResult.name
                locationManager.trackLocation = true
                selection += 2
            } catch {
                setUpLogger.error("\(error)")
            }
        }
    }
}


struct GuideView<TextContent: View, ActionContent: View>: View {
    let text: () -> TextContent
    let content: () -> ActionContent
    
    init(@ViewBuilder textContent: @escaping () -> TextContent, @ViewBuilder content: @escaping () -> ActionContent) {
        self.text = textContent
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Color(.black).opacity(0.98).ignoresSafeArea()
            VStack {
                text()
                    .padding(.bottom)
                content()
            }
            .font(.system(.title2, design: .serif, weight: .bold))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.bottom, 175)
            .padding(.horizontal)
        }
    }
}


struct SetUpSearchView: View {
    @EnvironmentObject private var weatherData: WeatherData
    @Binding var selection: Int
    @FocusState private var isFocused: Bool
    @State private var text = ""
    @State private var locations = [Location]()
    
    var body: some View {
        VStack {
            Text("Location")
            TextField("", text: $text)
                .searchTextField(text, _isFocused)
                .focused($isFocused)
                .font(.system(.title, design: .rounded, weight: .bold))
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
                        selection += 1
                    }
                }
            }
        }
        .font(.system(.title, design: .serif, weight: .bold))
        .foregroundStyle(.white)
        .padding()
        .background(.black.opacity(0.98))
        .onChange(of: text) {
            fetchLocations()
        }
    }
    
    private func fetchLocations() {
        Task {
            do {
                locations = try await APIClient.fetch(service: .location, forType: [Location].self, text)
            } catch {
                setUpLogger.error("\(error)")
            }
        }
    }
}
