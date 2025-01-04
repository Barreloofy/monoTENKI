//
//  monoTENKIApp.swift
//  monoTENKI
//
//  Created by Barreloofy on 12/31/24 at 11:19 PM.
//

import SwiftUI

@main
struct monoTENKIApp: App {
    @StateObject private var unitData = UnitData()
    var body: some Scene {
        WindowGroup {
            WeatherView()
                .environmentObject(unitData)
        }
    }
}
