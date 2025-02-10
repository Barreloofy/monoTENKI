//
//  TemperatureExtremesView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/6/25 at 2:27 AM.
//

import SwiftUI

struct TemperatureExtremesView: View {
    @EnvironmentObject private var unitData: UnitData
    let day: FutureDay
    
    init(for day: FutureDay) {
        self.day = day
    }
    
    var body: some View {
        HStack {
            Text("L: \(presentTemperature(unitData.temperature, day.mintempC))")
            Text("H: \(presentTemperature(unitData.temperature, day.maxtempC))")
        }
    }
}
