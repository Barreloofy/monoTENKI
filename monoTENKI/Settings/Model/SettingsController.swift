//
// SettingsController.swift
// monoTENKI
//
// Created by Barreloofy on 7/27/25 at 5:34 PM
//

import SwiftUI

@MainActor
@Observable
class SettingsController {
  var present = false

  func callAsFunction() { present.toggle() }
}

@MainActor
@propertyWrapper struct SettingsControllerWrapper: DynamicProperty {
  @State private var settingsController = SettingsController()

  var wrappedValue: Bool {
    get { settingsController.present }
    nonmutating set { settingsController.present = newValue }
  }

  var projectedValue: Binding<Bool> { $settingsController.present }

  var inject: SettingsController { settingsController }

  func callAsFunction() -> SettingsController {
    settingsController
  }
}


extension Bool {
  mutating func callAsFunction() { self.toggle() }
}
