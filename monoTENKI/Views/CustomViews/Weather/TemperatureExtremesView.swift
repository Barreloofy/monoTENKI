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
      Text("L: \(presentTemperature(for: unitData.temperature, with: day.mintempC))")
      Text("H: \(presentTemperature(for: unitData.temperature, with: day.maxtempC))")
    }
  }
}
