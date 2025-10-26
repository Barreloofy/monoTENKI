//
// String+KeyPath.swift
// monoTENKI
//
// Created by Barreloofy on 10/25/25 at 3:37 PM
//

extension String {
  /// Creates a new `String` from a static `KeyPath`.
  /// - Parameter keyPath: The `KeyPath` to the static property.
  init(_ keyPath: KeyPath<String.Type, String>) {
    self.init(String.self[keyPath: keyPath])
  }
}
