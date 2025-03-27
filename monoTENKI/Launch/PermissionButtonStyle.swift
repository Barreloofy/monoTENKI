//
//  PermissionButtonStyle.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/26/25 at 5:09 PM.
//

import SwiftUI

struct PermissionStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.system(.body, design: .monospaced, weight: .medium))
      .foregroundStyle(.white.opacity(configuration.isPressed ? 0.8 : 1))
      .padding(.vertical, 10)
      .padding(.horizontal, 25)
      .background {
        Capsule()
          .stroke(lineWidth: 2.5)
          .foregroundStyle(.white.opacity(configuration.isPressed ? 0.5 : 1))
      }
  }
}


extension ButtonStyle where Self == PermissionStyle {
  static var permission: PermissionStyle { PermissionStyle() }
}
