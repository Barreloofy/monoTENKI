//
//  monoTENKIApp.swift
//  monoTENKI
//
//  Created by Barreloofy on 12/31/24 at 11:19 PM.
//

import SwiftUI

@main
struct monoTENKIApp: App {
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @StateObject private var weatherData = WeatherData()
    @StateObject private var unitData = UnitData()
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                SetUpView(isFirstLaunch: $isFirstLaunch)
            } else {
                ViewManager()
            }
        }
        .environmentObject(weatherData)
        .environmentObject(unitData)
    }
}
