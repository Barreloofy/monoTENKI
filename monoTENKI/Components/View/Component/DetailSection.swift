//
// DetailSection.swift
// monoTENKI
//
// Created by Barreloofy on 4/12/25 at 11:31 PM.
//

import SwiftUI

struct DetailSection<Content: View>: View {
  let title: String
  @ViewBuilder let content: Content

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      Text(title)
        .titleFont()
        .underline()
        .layoutPriority(1)

      content
        .bodyFont()
        .offset(x: 10)
    }
    .accessibilityElement(children: .combine)
  }
}
