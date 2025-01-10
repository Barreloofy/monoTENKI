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
    @State private var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            GuidView(selection: $selection)
                .tag(0)
            GuideView2(selection: $selection)
                .tag(1)
            GuideView3(selection: $selection)
                .tag(2)
            GuideView4()
                .tag(3)
        }
    }
}

#Preview {
    SetUpView()
        .environmentObject(UnitData())
        .environmentObject(WeatherData())
}


struct GuidView: View {
    @Binding var selection: Int
    
    var body: some View {
        ZStack {
            Color(.black).opacity(0.98).ignoresSafeArea()
            VStack {
                Text("Greetings fellow weather watcher!")
                Text("first let's setup a few things")
                Text("before occupying ourselves with the more interesting thing in life")
                Text("The Weather!")
                    .padding(.bottom)
                Button {
                    guard selection < 2 else { return }
                    selection += 1
                } label: {
                    Text("Get started")
                        .padding(5)
                        .foregroundStyle(.black)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .font(.system(.title2, design: .serif, weight: .bold))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.bottom, 175)
            .padding(.horizontal)
        }
    }
}


struct GuideView2: View {
    @EnvironmentObject private var weatherData: WeatherData
    @Binding var selection: Int
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            Color(.black).opacity(0.98).ignoresSafeArea()
            VStack {
                Text("Grant localtion access to")
                Text("get the most accurate weather")
                Button {
                    locationManager.requestAuthorization()
                } label: {
                    Text("Grand permission")
                        .padding(5)
                        .foregroundStyle(.black)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Button {
                    selection += 1
                } label: {
                    Text("No, thank you!")
                        .padding(5)
                        .foregroundStyle(.black)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .font(.system(.title2, design: .serif, weight: .bold))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.bottom, 175)
            .padding(.horizontal)
        }
        .onChange(of: locationManager.currentLocation) {
            setToCurrentLocation()
        }
    }
    
    private func setToCurrentLocation() {
        Task {
            do {
                guard let query = locationManager.stringLocation else { throw NSError(domain: "Location nil", code: 1) }
                let results = try await APIClient.fetch(service: .location, forType: [Location].self, query)
                guard let firstResult = results.first else { throw NSError(domain: "Location nil", code: 1) }
                weatherData.currentLocation = firstResult.name
                selection += 2
            } catch {
                setUpLogger.error("\(error)")
            }
        }
    }
}


struct GuideView3: View {
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


struct GuideView4: View {
    @EnvironmentObject private var unitData: UnitData
    @AppStorage("isfirstlaunch") var isFirstLaunch = true
    
    var body: some View {
        ZStack {
            Color(.black).opacity(0.98).ignoresSafeArea()
            VStack {
                Text("One more thing, please tell us")
                Text("your preference: American or Rest of the world?")
                HStack {
                    Button {
                        unitData.temperature = .fahrenheit
                        isFirstLaunch = false
                    } label: {
                        Text("Fahrenheit")
                            .padding(5)
                            .foregroundStyle(.black)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding()
                    Button {
                        unitData.temperature = .celsius
                        isFirstLaunch = false
                    } label: {
                        Text("Celsius")
                            .padding(5)
                            .foregroundStyle(.black)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding()
                }
            }
            .font(.system(.title2, design: .serif, weight: .bold))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.bottom, 175)
            .padding(.horizontal)
        }
    }
}
