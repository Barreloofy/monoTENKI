//
//  SetUpView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/8/25 at 2:57 PM.
//

import SwiftUI
import OSLog

private let logger = Logger(subsystem: "com.monoTENKI.SetUp", category: "Error")

struct SetUpView: View {
    @EnvironmentObject private var weatherData: WeatherData
    @EnvironmentObject private var unitData: UnitData
    @ObservedObject private var locationManager = LocationManager.shared
    @State private var selection = 0
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        TabView(selection: $selection) {
            GuideView {
                Text(DesignSystem.AppText.SetupText.greetingsText)
            } content: {
                Button(DesignSystem.AppText.SetupText.greetingsButton) {
                    selection += 1
                }
                .buttonStyle(.monoBordered)
            }
            .tag(0)
            
            GuideView {
                Text(DesignSystem.AppText.SetupText.permissionText)
            } content: {
                Button(DesignSystem.AppText.SetupText.permissionButtonGrand) {
                    locationManager.requestAuthorization()
                }
                .buttonStyle(.monoBordered)
                .onChange(of: locationManager.currentLocation) { setWeatherToCurrentLocation() }
                
                Button(DesignSystem.AppText.SetupText.permissionButtonDeny) {
                    selection += 1
                }
                .buttonStyle(.monoBordered)
            }
            .tag(1)
            
            SetUpSearchView(selection: $selection)
            .tag(2)
            
            GuideView {
                Text(DesignSystem.AppText.SetupText.unitText)
            } content: {
                Button(DesignSystem.AppText.SetupText.unitButtonMetric) {
                    unitData.setToMetric()
                    isFirstLaunch = false
                }
                .buttonStyle(.monoBordered)
                
                Button(DesignSystem.AppText.SetupText.unitButtonImperial) {
                    unitData.setToImperial()
                    isFirstLaunch = false
                }
                .buttonStyle(.monoBordered)
            }
            .tag(3)
        }
        .background(.black).opacity(0.98).padding(-1).ignoresSafeArea()
        /*
            Temporary fix for view rendering out of sync glitch until Apple resolves the issue.
            See here for more details: https://stackoverflow.com/questions/79441756/swiftui-sheet-causing-white-flickering-of-background
          */
    }
    
    private func setWeatherToCurrentLocation() {
        Task {
            do {
                try await weatherData.setWeatherToCurrentLocation()
                selection += 2
            } catch {
                logger.error("\(error)")
            }
        }
    }
}


private struct GuideView<TextContent: View, ActionContent: View>: View {
    let text: TextContent
    let content: ActionContent
    
    init(@ViewBuilder textContent: () -> TextContent, @ViewBuilder content: () -> ActionContent) {
        self.text = textContent()
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Color(.black).opacity(0.98).ignoresSafeArea()
            VStack {
                text
                .padding(.bottom)
                content
            }
            .font(.system(.title2, design: .serif, weight: .bold))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.bottom, 175)
            .padding(.horizontal)
        }
    }
}


private struct SetUpSearchView: View {
    @EnvironmentObject private var weatherData: WeatherData
    @State private var locations = [Location]()
    @State private var text = ""
    @FocusState private var isFocused: Bool
    @Binding var selection: Int
    
    var body: some View {
        VStack {
            Text("Location")
            
            TextField("", text: $text)
                .searchTextField(text, _isFocused)
                .focused($isFocused)
                .font(.system(.title, design: .rounded, weight: .bold))
            
            ScrollView {
                ForEach(locations) { location in
                    SearchItemView(location: LocationKey(name: location.name, country: location.country))
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
                locations = try await APIClient.fetch(service: .location, forType: [Location].self, query: text)
            } catch {
                logger.error("\(error)")
            }
        }
    }
}
