//
// Bool+Toggled.swift
// monoTENKI
//
// Created by Barreloofy on 9/3/25 at 1:57 PM
//

extension Bool {
  /// Returns the inverse of the current boolean value.
  /// - Returns: `true` if `self` is `false`, otherwise `false`.
  func toggled() -> Bool {
    self ? false : true
  }
}
