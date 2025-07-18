//
//  DismissIcon.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/28/25 at 7:10 PM.
//

import SwiftUI

struct DismissIcon: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()

    path.move(to: .zero)
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

    path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

    return path
  }

  func styled() -> some View {
    DismissIcon()
      .stroke(lineWidth: 3)
      .frame(width: 20, height: 20)
  }
}
