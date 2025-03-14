//
//  SetupView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/8/25 at 2:57 PM.
//

import SwiftUI

struct SetupView: View {
    @EnvironmentObject private var weatherData: WeatherData
    @EnvironmentObject private var unitData: UnitData
    @ObservedObject private var locationManager = LocationManager.shared
    @State private var selection = 0
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        TabView(selection: $selection) {
            
            GuideView(
                label: {
                    Text(DesignSystem.AppText.SetupText.greetingsText)
                },
                action: {
                    Button(DesignSystem.AppText.SetupText.greetingsButton) {
                        selection += 1
                    }
                    .buttonStyle(.monoBordered)
                })
                .tag(0)
            
            GuideView(
                label: {
                    Text(DesignSystem.AppText.SetupText.permissionText)
                },
                action: {
                    Button(DesignSystem.AppText.SetupText.permissionButtonGrand) {
                        locationManager.requestAuthorization()
                    }
                    .buttonStyle(.monoBordered)
                    .onChange(of: locationManager.currentLocation) { setWeatherToCurrentLocation() }
                    
                    Button(DesignSystem.AppText.SetupText.permissionButtonDeny) {
                        selection += 1
                    }
                    .buttonStyle(.monoBordered)
                })
                .tag(1)
            
            SetUpSearchView(selection: $selection)
                .tag(2)
            
            GuideView(
                label: {
                    Text(DesignSystem.AppText.SetupText.unitText)
                },
                action: {
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
                })
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
            guard (try? await weatherData.setWeatherToCurrentLocation()) != nil else { return }
            selection += 2
        }
    }
}
