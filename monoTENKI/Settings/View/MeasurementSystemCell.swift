//
//  MeasurementSystemCell.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/28/25 at 6:29 PM.
//

import SwiftUI

struct MeasurementSystemCell: View {
  @Environment(\.measurementSystem) private var measurementSystem
  let measurement: MeasurementSystem

  var body: some View {
    Text(measurement.rawValue)
      .font(.system(.subheadline, design: .monospaced, weight: .medium))
      .overlay(alignment: .bottom) {
        if measurementSystem == measurement {
          Rectangle()
            .frame(height: 2)
        }
      }
  }
}
