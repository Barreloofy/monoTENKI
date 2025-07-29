//
// SheetController.swift
// monoTENKI
//
// Created by Barreloofy on 7/27/25 at 5:34 PM
//

import SwiftUI

@MainActor
@Observable
class SheetController {
  var present = false

  func callAsFunction() { present() }
}


@MainActor
@propertyWrapper struct SheetControllerWrapper: DynamicProperty {
  @State private var settingsController = SheetController()

  var wrappedValue: Bool {
    get { settingsController.present }
    nonmutating set { settingsController.present = newValue }
  }

  var projectedValue: Binding<Bool> { $settingsController.present }

  func callAsFunction() -> SheetController {
    settingsController
  }
}


extension View {
  func sheetController(_ sheetController: SheetController) -> some View {
    environment(sheetController)
  }
}
