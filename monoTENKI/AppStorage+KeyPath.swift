//
// AppStorage+KeyPath.swift
// monoTENKI
//
// Created by Barreloofy on 10/25/25 at 3:37 PM
//

import SwiftUI

extension AppStorage where Value: RawRepresentable, Value.RawValue == String {
  init(wrappedValue: Value, _ keyPath: KeyPath<String.Type, String>, store: UserDefaults? = nil) {
    self.init(wrappedValue: wrappedValue, String(keyPath), store: store)
  }
}


extension AppStorage where Value == Bool {
  init(wrappedValue: Value, _ keyPath: KeyPath<String.Type, String>, store: UserDefaults? = nil) {
    self.init(wrappedValue: wrappedValue, String(keyPath), store: store)
  }
}
