//
// UserDefault.swift
// monoTENKI
//
// Created by Barreloofy on 6/22/25 at 6:25 PM
//

import Foundation

/// Convenience wrapper for UserDefaults.
/// Access the underlying value through the `value` stored-property.
/// - Parameters:
///   - key: The key with which to associate the value.
///   - defaultValue: The value to set when no value can be found with 'key'.
///   - container: The UserDefaults instance to use.
struct UserDefault<Value> {
  let key: String
  let defaultValue: Value
  let container: UserDefaults

  var value: Value { didSet { container.set(value, forKey: key) } }

  init(key: String, defaultValue: Value, container: UserDefaults = .standard) {
    self.key = key
    self.defaultValue = defaultValue
    self.container = container
    self.value = container.object(forKey: key) as? Value ?? defaultValue
  }
}
