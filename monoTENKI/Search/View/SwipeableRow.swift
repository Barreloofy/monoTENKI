//
//  SwipeableRow.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/7/25 at 7:50 PM.
//

import SwiftUI

struct SwipeableRow<Content: View>: View {
  @Environment(\.colorScheme) private var colorScheme
  @State private var offset: CGFloat = .zero

  let allowSwipe: Bool
  var action: () -> Void = {}
  @ViewBuilder let content: Content

  var body: some View {
    switch allowSwipe {
    case true:
      ZStack {
        Color(colorScheme.foreground).padding(1)
        content
          .background(colorScheme.background)
          .offset(x: offset)
          .gesture(
            DragGesture()
              .onChanged { value in
                let dragValue = value.translation.width

                guard dragValue < .zero else { return }
                withAnimation(.smooth) { offset = dragValue }
              }
              .onEnded { value in
                let dragValue = value.translation.width

                withAnimation(.smooth) {
                  if dragValue < -150 {
                    action()
                  } else {
                    offset = .zero
                  }
                }
              })
      }
    case false:
      content
    }
  }
}
