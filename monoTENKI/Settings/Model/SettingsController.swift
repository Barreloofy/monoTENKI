//
// SheetController.swift
// monoTENKI
//
// Created by Barreloofy on 7/27/25 at 5:34 PM
//

import SwiftUI

@MainActor
@Observable
final class SheetController {
  var present = false

  func callAsFunction() { present() }
}

extension View {
  func sheetController(_ sheetController: SheetController) -> some View {
    environment(sheetController)
  }
}
