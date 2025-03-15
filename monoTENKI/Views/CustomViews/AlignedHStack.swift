//
//  HStackContent.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/17/25 at 9:03 PM.
//

import SwiftUI

struct AlignedHStack<Content: View>: View {
  let alignment: HorizontalAlignment
  @ViewBuilder var content: Content

  var body: some View {
    HStack {
      if alignment == .leading {
        content
        Spacer()
      } else {
        Spacer()
        content
      }
    }
  }
}
