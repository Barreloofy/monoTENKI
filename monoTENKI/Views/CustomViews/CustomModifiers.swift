//
//  CustomModifiers.swift
//  monoTENKI
//
//  Created by Barreloofy on 2/7/25 at 7:31 PM.
//

import SwiftUI

struct TipsStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.system(.footnote, design: .serif, weight: .bold))
      .padding(.vertical, 5)
  }
}

extension View {
  func tipsStyle() -> some View {
    modifier(TipsStyle())
  }
}

struct MonoBordered: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(5)
      .foregroundStyle(.black)
      .background(.white)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
      .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
  }
}

extension ButtonStyle where Self == MonoBordered {
  static var monoBordered: MonoBordered {
    return MonoBordered()
  }
}
