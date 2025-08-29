//
// ImageConfiguration.swift
// monoTENKI
//
// Created by Barreloofy on 8/28/25 at 8:35 PM
//

import SwiftUI

extension Image {
  func configure() -> some View {
    self
      .resizable()
      .scaledToFit()
      .fontWeight(.regular)
  }
}
