//
// MessageConfiguration.swift
// monoTENKI
//
// Created by Barreloofy on 7/18/25 at 6:45 PM
//

import SwiftUI

struct MessageConfiguration: ViewModifier {
  func body(content: Content) -> some View {
    content
      .footnoteFont()
      .fontWeight(.medium)
      .lineLimit(nil)
  }
}


extension View {
  func configureMessage() -> some View {
    modifier(MessageConfiguration())
  }
}
