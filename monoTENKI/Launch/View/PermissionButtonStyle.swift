//
//  PermissionButtonStyle.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/26/25 at 5:09 PM.
//

import SwiftUI

struct PermissionStyle: ButtonStyle {
  @ColorSchemeWrapper private var colorSchemeWrapper

  func makeBody(configuration: Configuration) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 8)
        .stroke(lineWidth: 2.5)

      configuration.label
        .foregroundStyle(colorSchemeWrapper.opacity(configuration.isPressed ? 0.8 : 1))
        .padding(10)
    }
    .contentShape(RoundedRectangle(cornerRadius: 8))
  }
}


extension ButtonStyle where Self == PermissionStyle {
  static var permission: PermissionStyle { PermissionStyle() }
}
