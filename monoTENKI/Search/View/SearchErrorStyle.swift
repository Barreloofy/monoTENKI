//
//  SearchErrorStyle.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/27/25 at 4:43 PM.
//

import SwiftUI

struct SearchErrorStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.footnote)
      .multilineTextAlignment(.leading)
      .lineLimit(nil)
  }
}


extension View {
  func searchErrorStyle() -> some View {
    modifier(SearchErrorStyle())
  }
}
