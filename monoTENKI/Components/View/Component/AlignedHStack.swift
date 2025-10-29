//
// AlignedHStack.swift
// monoTENKI
//
// Created by Barreloofy on 3/27/25 at 4:31 PM.
//

import SwiftUI

struct AlignedHStack<Content: View>: View {
  let alignment: HorizontalAlignment
  @ViewBuilder let content: Content

  var body: some View {
    HStack {
      if alignment == .leading {
        content
        Spacer()
      } else if alignment == .trailing {
        Spacer()
        content
      } else {
        Spacer()
        content
        Spacer()
      }
    }
  }
}
