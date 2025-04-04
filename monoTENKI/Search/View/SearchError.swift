//
//  SearchError.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/27/25 at 4:43 PM.
//

import SwiftUI

struct SearchError: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.footnote)
      .multilineTextAlignment(.leading)
      .lineLimit(nil)
  }
}


extension View {
  func searchError() -> some View {
    modifier(SearchError())
  }
}
