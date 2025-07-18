//
// ErrorTextConfiguration.swift
// monoTENKI
//
// Created by Barreloofy on 7/18/25 at 6:45 PM
//

import SwiftUI

struct ErrorTextConfiguration: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.body)
      .fontWeight(.medium)
      .lineLimit(nil)
  }
}


extension View {
  func errorTextConfiguration() -> some View {
    modifier(ErrorTextConfiguration())
  }
}
