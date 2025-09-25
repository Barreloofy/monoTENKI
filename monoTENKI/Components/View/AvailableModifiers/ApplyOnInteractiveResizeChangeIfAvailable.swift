//
// ApplyOnInteractiveResizeChangeIfAvailable.swift
// monoTENKI
//
// Created by Barreloofy on 9/25/25 at 12:39 PM
//

import SwiftUI

struct ApplyOnInteractiveResizeChangeIfAvailable: ViewModifier {
  let action: (Bool) -> Void

  func body(content: Content) -> some View {
    if #available(iOS 26.0, *) {
      content
        .onInteractiveResizeChange { isResizing in
          action(isResizing)
        }
    } else {
      content
    }
  }
}


extension View {
  func applyOnInteractiveResizeChangeIfAvailable(
    _ action: @escaping (_ isResizing: Bool) -> Void
  ) -> some View {
    modifier(ApplyOnInteractiveResizeChangeIfAvailable(action: action))
  }
}
