//
//  SelectedStyle.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/28/25 at 6:29 PM.
//

import SwiftUI

struct SelectedStyle<T: Equatable>: ViewModifier {
  @Binding var value: T

  let target: T

  func body(content: Content) -> some View {
    content
      .overlay(alignment: .bottom) {
        Rectangle()
          .frame(height: value == target ? 2 : 0)
      }
      .onTapGesture { value = target }
  }
}


extension View {
  func selectedStyle<T: Equatable>(target: T, value: Binding<T>) -> some View {
    modifier(SelectedStyle(value: value, target: target))
  }

  func selectedStyle() -> some View {
    self
      .overlay(alignment: .bottom) {
        Rectangle()
          .frame(height: 2)
      }
  }
}
