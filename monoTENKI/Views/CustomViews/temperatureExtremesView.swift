//
//  temperatureExtremesView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/6/25 at 2:27 AM.
//

import SwiftUI

struct temperatureExtremesView: View {
    @EnvironmentObject private var unitData: UnitData
    let mintemp: Double
    let maxtemp: Double
    
    var body: some View {
        HStack {
            Text("L: \(presentTemperature(unitData.temperature, mintemp))")
            Text("H: \(presentTemperature(unitData.temperature, maxtemp))")
        }
    }
}
