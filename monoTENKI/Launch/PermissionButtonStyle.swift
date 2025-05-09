//
//  PermissionButtonStyle.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/26/25 at 5:09 PM.
//

import SwiftUI

struct PermissionStyle: ButtonStyle {
  @Environment(\.colorScheme) private var colorScheme

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.system(.body, design: .monospaced, weight: .medium))
      .foregroundStyle(colorScheme.foreground.opacity(configuration.isPressed ? 0.8 : 1))
      .frame(minWidth: 150)
      .padding(10)
      .background {
        Capsule()
          .stroke(lineWidth: 2.5)
          .foregroundStyle(colorScheme.foreground.opacity(configuration.isPressed ? 0.5 : 1))
      }
      .contentShape(Capsule())
  }
}


extension ButtonStyle where Self == PermissionStyle {
  static var permission: PermissionStyle { PermissionStyle() }
}
