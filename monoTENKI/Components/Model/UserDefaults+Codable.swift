//
// UserDefaults+Codable.swift
// monoTENKI
//
// Created by Barreloofy on 10/22/25 at 9:23 PM
//

import Foundation

extension UserDefaults {
  /// Sets the value of the specified default key.
  /// - Parameters:
  ///   - value: The value to store in the defaults database.
  ///   - key: The storage-key with which to associate the value.
  func set(_ value: some Codable, for key: StorageKeys) {
    let data = try? JSONEncoder().encode(value)

    set(data, forKey: key.rawValue)
  }
  
  /// Returns the value associated with the specified key.
  /// - Parameters:
  ///   - key: The storage-key with which to associate the value.
  ///   - defaultValue: The default value if no value of the provided type is specified for the given key.
  /// - Returns: The value associated with the specified key, or nil if the key does not exist or its value doesn't match.
  func codableType<Value: Codable>(for key: StorageKeys, defaultValue: Value) -> Value {
    guard
      let data = data(forKey: key.rawValue),
      let value = try? JSONDecoder().decode(Value.self, from: data)
    else { return defaultValue }

    return value
  }
}
