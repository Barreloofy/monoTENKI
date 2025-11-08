//
// RainView.swift
// monoTENKI
//
// Created by Barreloofy on 11/4/25 at 5:10 PM
//

import SwiftUI

struct RainView: View {
  let precipitationChance: Int

  private var formattedChance: String {
    precipitationChance.formatted(.percent)
  }

  var body: some View {
    Label(formattedChance, systemImage: "drop.fill")
      .accessibilityLabel("Next hour \(precipitationChance) precipitation chance")
      .visible(precipitationChance >= 33)
  }
}
