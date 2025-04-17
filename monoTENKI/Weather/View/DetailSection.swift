//
//  DetailSection.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/12/25 at 11:31 PM.
//

import SwiftUI

struct DetailSection<Content: View>: View {
  let title: String
  @ViewBuilder let content: Content

  var body: some View {
    Text(title)
      .font(.title)
      .underline()
    VStack(alignment: .leading) {
      content
    }
    .offset(x: 10)
  }
}
