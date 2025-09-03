//
// String+StorageKeys.swift
// monoTENKI
//
// Created by Barreloofy on 9/3/25 at 2:04 PM
//

extension String {
  /// Access `StorageKeys` directly from a `String` type.
  /// - Parameter key: The appropriate `StorageKeys` key.
  /// - Returns: The `String` representation of `key`.
  static func key(_ key: StorageKeys) -> String {
    key.rawValue
  }
}
