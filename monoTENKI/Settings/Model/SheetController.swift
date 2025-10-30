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
  var present: Binding<Bool>

  init(present: Binding<Bool>) {
    self.present = present
  }
}
