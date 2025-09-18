//
// TrailingLabelStyle.swift
// monoTENKI
//
// Created by Barreloofy on 9/18/25 at 11:24 AM
//

import SwiftUI

struct TrailingLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.title
      configuration.icon
    }
  }
}


extension LabelStyle where Self == TrailingLabelStyle {
  static var trailing: TrailingLabelStyle { TrailingLabelStyle() }
}
