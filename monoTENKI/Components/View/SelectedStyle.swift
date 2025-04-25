//
//  SelectedStyle.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/28/25 at 6:29 PM.
//

import SwiftUI

struct SelectedStyle<T: Equatable>: ViewModifier {
  let target: T
  @Binding var value: T

  func body(content: Content) -> some View {
    content
      .overlay(alignment: .bottom) {
        if target == value {
          Rectangle()
            .frame(height: 2)
        }
      }
      .onTapGesture { value = target }
  }
}


extension View {
  func selectedStyle<T: Equatable>(target: T, value: Binding<T>) -> some View {
    modifier(SelectedStyle(target: target, value: value))
  }
}
