//
// SwipeableButtonStyle.swift
// monoTENKI
//
// Created by Barreloofy on 11/2/25 at 10:06 PM
//

import SwiftUI

/// A primitive button style that adds swipe gesture support.
struct SwipeableButtonStyle: PrimitiveButtonStyle {
  @Environment(\.colorScheme) private var colorScheme
  @StyleMode private var styleMode

  @State private var offset = 0.0
  @State private var frame: CGRect?
  @State private var isPressed = false
  @State private var isSwiping = false

  let enabled: Bool
  let accessibilityMessage: String
  let threshold: Double
  let successOffset: Double
  let swipeAction: () -> Void

  private var swipeGesture: some Gesture {
    DragGesture(minimumDistance: 50)
      .onChanged { value in
        let newOffset = value.translation.width

        if newOffset < 0 {
          isSwiping = true
        } else {
          isSwiping = false
        }

        if newOffset <= 0 { offset = newOffset }
      }
      .onEnded { value in
        let endOffset = value.translation.width

        offset = endOffset

        if offset <= threshold {
          swipeAction()
          offset = successOffset
        } else {
          offset = 0
        }
      }
  }

  private func tapGesture(action: @escaping () -> Void) -> some Gesture {
    DragGesture(minimumDistance: 0, coordinateSpace: .global)
      .onChanged { value in
        if let frame, frame.contains(value.location) && isSwiping == false {
          isPressed = true
        } else {
          isPressed = false
        }
      }
      .onEnded { value in
        defer { isPressed = false }

        guard
          let frame,
          frame.contains(value.location),
          value.translation.width >= 0
        else { return }

        action()
      }
  }

  private func accessibilityAction(_: Any) -> Void {
    offset = successOffset
    swipeAction()

    UIAccessibility.post(
      notification: .announcement,
      argument: accessibilityMessage)
  }

  func makeBody(configuration: Configuration) -> some View {
    switch enabled {
    case true:
      ZStack {
        styleMode.padding(1) // SwiftUI bug; Stackoverflow id: 79441756.

        configuration.label
          .onGeometryChange(for: CGRect.self) { geometryProxy in
            geometryProxy.frame(in: .global)
          } action: { newValue in
            frame = newValue
          }
          .contentShape(Rectangle())
          .gesture(tapGesture(action: configuration.trigger))
          .simultaneousGesture(swipeGesture)

          .opacity(isPressed ? 0.5 : 1)
          .background(colorScheme.background)
          .offset(x: offset)
          .sensoryFeedback(trigger: offset < threshold) { offset < threshold ? .impact : nil }
          .animating(offset, with: .smooth(duration: 1))

          .accessibilityAddTraits(.isSelected)
          .accessibilityAdjustableAction(accessibilityAction)
          .accessibilityHint("To perform swipe action")
      }
    case false:
      Button(configuration)
        .accessibilityAddTraits(.isSelected)
    }
  }
}


extension SwipeableButtonStyle {
  /// - Parameters:
  ///   - enabled: If swipe gesture should be enabled.
  ///   - accessibilityMessage: The accessibility message to announce after `swipeAction` was called.
  ///   - swipeThreshold: The required distance before swipe gesture succeeds.
  ///   - swipeAction: The action to perform on succesful swipe.
  ///   - resetOffset: If swipe offset should be reset on success.
  init(
    enabled: Bool,
    accessibilityMessage: String,
    swipeThreshold: Double = -100,
    resetOffset: Bool = true,
    swipeAction: @escaping () -> Void)
  {
    self.init(
      enabled: enabled,
      accessibilityMessage: accessibilityMessage,
      threshold: swipeThreshold,
      successOffset: resetOffset ? 0 : -999,
      swipeAction: swipeAction)
  }
}
