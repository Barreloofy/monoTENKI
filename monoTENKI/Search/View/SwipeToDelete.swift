//
//  SwipeToDelete.swift
//  monoTENKI
//
//  Created by Barreloofy on 5/3/25.
//

import SwiftUI
import UIKit

struct SwipeToDelete: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @ColorSchemeWrapper private var colorSchemeWrapper

  @State private var offset: CGFloat = .zero

  let isEnabled: Bool
  let action: () -> Void

  private let minimumThreshold: CGFloat = 25
  private let actionThreshold: CGFloat = -100
  private let deletedOffset: CGFloat = -1000

  func body(content: Content) -> some View {
    ZStack {
      switch isEnabled {
      case false:
        content
      case true:
        ZStack {
          colorSchemeWrapper.padding(1) // .padding(1) needed to fix a SwiftUI rendering bug. Stackoverflow id: 79441756

          content
            .accessibilityAdjustableAction { _ in
              guard isEnabled else { return }

              action()
              UIAccessibility.post(
                notification: .announcement,
                argument: "Deleted item")
            }
            .accessibilityHint("To delete")
            .background(colorScheme.background)
            .offset(x: offset)
            .gesture(
              DragGesture(minimumDistance: minimumThreshold)
                .onChanged { value in
                  let dragValue = value.translation.width

                  guard dragValue < .zero else { return }

                  offset = dragValue
                }
                .onEnded { value in
                  let dragValue = value.translation.width

                  if dragValue < actionThreshold {
                    offset = deletedOffset
                    withAnimation(reduceMotion ? nil : .smooth(duration: 1)) { action() }
                  } else {
                    offset = .zero
                  }
                })
            .animation(reduceMotion ? nil : .smooth(duration: 1), value: offset)
            .sensoryFeedback(.impact, trigger: offset < actionThreshold) { old, new in
              new == true && new != old
            }
        }
      }
    }
  }
}


extension View {
  func swipeToDelete(isEnabled: Bool, action: @escaping () -> Void) -> some View {
    modifier(SwipeToDelete(isEnabled: isEnabled, action: action))
  }
}
