//
// NightToggle.swift
// monoTENKI
//
// Created by Barreloofy on 7/29/25 at 11:47 AM
//

import SwiftUI

struct NightToggle: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @Environment(\.colorScheme) private var colorScheme

  @AppStorage(StorageKeys.nightVision.rawValue) private var nightVision = false

  var body: some View {
    HStack {
      Text("Night Vision")

      Spacer()

      RoundedRectangle(cornerRadius: 8)
        .fill(colorScheme.foreground)
        .frame(width: 35, height: 20)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .frame(
          width: 78,
          alignment: nightVision ? .trailing : .leading)
        .background(
          nightVision ? .nightRed : colorScheme.background,
          in: RoundedRectangle(cornerRadius: 8))
        .animation(reduceMotion ? nil : .easeOut, value: nightVision)
        .sensoryFeedback(.impact, trigger: nightVision)
        .onTapGesture { nightVision.toggle() }
    }
  }
}
