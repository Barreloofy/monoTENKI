//
// NightToggle.swift
// monoTENKI
//
// Created by Barreloofy on 7/29/25 at 11:47 AM
//

import SwiftUI

struct NightToggle: View {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.nightVision) private var nightVision

  var body: some View {
    LabeledContent(
      content: {
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
          .animating(nightVision, with: .easeOut)
          .sensoryFeedback(.impact, trigger: nightVision)
          .onTapGesture {
            UserDefaults.standard.set(nightVision.toggled(), forKey: StorageValues.nightVision.key)
          }
      },
      label: {
        Label("Night Vision", systemImage: "lightswitch.on")
      })
  }
}


#Preview {
  NightToggle()
}
