//
//  SwipeableRow.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/7/25 at 7:50 PM.
//

import SwiftUI

struct SwipeableRow<Content: View>: View {
  @Environment(\.colorScheme) private var colorScheme

  @State private var offset: CGFloat = 0

  let allowSwipe: Bool

  var action: () -> Void = {}

  @ViewBuilder let content: Content

  var body: some View {
    switch allowSwipe {
    case true:
      ZStack {
        Color(colorScheme == .light ? .black : .white).padding(1)
        content
          .background(colorScheme == .light ? .white : .black)
          .gesture(
            DragGesture()
              .onChanged { value in
                let dragValue = value.translation.width

                guard dragValue < 0 else { return }
                withAnimation(.smooth) {
                  offset = dragValue
                }
              }
              .onEnded { value in
                withAnimation(.smooth) {
                  let dragValue = value.translation.width

                  if dragValue < -200 {
                    action()
                  } else {
                    offset = 0
                  }
                }
              }
          )
          .offset(x: offset)
      }
    case false:
      content
    }
  }
}
