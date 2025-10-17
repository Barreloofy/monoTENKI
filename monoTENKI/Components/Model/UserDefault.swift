//
// UserDefault.swift
// monoTENKI
//
// Created by Barreloofy on 6/22/25 at 6:25 PM
//

import Foundation

/// A custom "wrapper" for `UserDefaults` that works with `@Observable` properties.
///
/// Use this type's callAsFunction methods to read and write to `value`.
/// ```swift
/// var location = UserDefault(key: "location", "London")
///
/// showRestaurants(for: location())
///
/// location(getLocation())
/// ```
struct UserDefault<Value: Codable> {
  let key: String
  let defaultValue: Value
  let container: UserDefaults

  var value: Value { didSet { container.set(try? JSONEncoder().encode(value), forKey: key) } }

  /// - Parameters:
  ///   - key: The key of the value stored in `UserDefaults`.
  ///   - defaultValue: The value to use when no value corresponding to `Key` in `UserDefaults` can be found.
  ///   - container: The `UserDefaults` container to read and write to.
  init(key: String, defaultValue: Value, container: UserDefaults = .standard) {
    self.key = key
    self.defaultValue = defaultValue
    self.container = container
    self.value = container.object(forKey: key) as? Value ?? defaultValue
  }

  /// - Parameters:
  ///   - key: The appropriate `StorageKeys` key.
  ///   - defaultValue: The value to use when no value corresponding to `Key` in `UserDefaults` can be found.
  ///   - container: The `UserDefaults` container to read and write to.
  init(key: StorageKeys, defaultValue: Value, container: UserDefaults = .standard) {
    self.key = key.rawValue
    self.defaultValue = defaultValue
    self.container = container

    let data = container.object(forKey: key.rawValue) as! Data
    self.value = try! JSONDecoder().decode(Value.self, from: data)
  }

  func callAsFunction() -> Value {
    value
  }

  mutating func callAsFunction(_ newValue: Value) {
    value = newValue
  }
}
