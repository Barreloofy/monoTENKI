//
//  SwipeToDelete.swift
//  monoTENKI
//
//  Created by Barreloofy on 5/3/25.
//

import SwiftUI

struct SwipeToDelete: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme

  @State private var offset: CGFloat = .zero

  let isEnabled: Bool
  let action: () -> Void

  func body(content: Content) -> some View {
    ZStack {
      colorScheme.foreground.padding(1)
      content
        .background(colorScheme.background)
        .offset(x: offset)
        .gesture(
          DragGesture()
            .onChanged { value in
              let dragValue = value.translation.width

              guard dragValue < .zero else { return }

              offset = dragValue
            }
            .onEnded { value in
              let dragValue = value.translation.width

              if dragValue < -200 {
                offset = -1000
                withAnimation(.smooth(duration: 1)) { action() }
              } else {
                offset = .zero
              }
            },
          isEnabled: isEnabled)
        .animation(.smooth(duration: 1), value: offset)
    }
  }
}


extension View {
  func swipeToDelete(isEnabled: Bool, action: @escaping () -> Void) -> some View {
    modifier(SwipeToDelete(isEnabled: isEnabled, action: action))
  }
}
