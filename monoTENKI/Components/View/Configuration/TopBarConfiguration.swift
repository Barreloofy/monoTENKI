//
// TopBarConfiguration.swift
// monoTENKI
//
// Created by Barreloofy on 7/16/25 at 3:16 PM
//

import SwiftUI

struct TopBarConfiguration: ViewModifier {
  func body(content: Content) -> some View {
    content
      .titleFont()
      .fontWeight(.bold)
  }
}


extension View {
  func configureTopBar() -> some View {
    modifier(TopBarConfiguration())
  }
}
