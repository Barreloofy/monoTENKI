//
// UserDefaults+Codable.swift
// monoTENKI
//
// Created by Barreloofy on 10/29/25 at 12:27 PM
//

import Foundation

extension UserDefaults {
  /// Sets the value of the specified key path.
  ///
  /// - Important: Errors thrown during encoding will lead to a runtime crash.
  ///
  /// - Parameters:
  ///   - keyPath: The key path to the `StorageValues` instance.
  ///   - value: The `Codable` value to store in the defaults database.
  func setCodable<Value>(
    _ keyPath: KeyPath<StorageValues<Value>.Type, StorageValues<Value>>,
    value: Value)
  where Value: Codable {
    let storageValue = StorageValues.self[keyPath: keyPath]

    let data = try! JSONEncoder().encode(value)

    set(data, forKey: storageValue.key)
  }

  /// Returns the `Codable` value associated with the specified key path.
  ///
  /// - Important: Errors thrown during decoding will lead to a runtime crash.
  /// Furthermore if no `Codable` value is associated with the specified key path,
  /// returns the default value stored in the `StorageValues` instance.
  ///
  /// - Parameter keyPath: The key path to the `StorageValues` instance.
  /// - Returns: The `Codable` value associated with the specified key path.
  func codableType<Value>(
    _ keyPath: KeyPath<StorageValues<Value>.Type, StorageValues<Value>>)
  -> Value where Value: Codable {
    let storageValue = StorageValues.self[keyPath: keyPath]

    guard let data = data(forKey: storageValue.key) else { return storageValue.defaultValue }

    return try! JSONDecoder().decode(Value.self, from: data)
  }
}


extension UserDefaults {
  /// Sets the value of the specified key path.
  /// - Parameters:
  ///   - keyPath: The key path to the `StorageValues` instance.
  ///   - value: The `RawRepresentable` value to store in the defaults database.
  func setRawRepresentable<Value>(
    _ keyPath: KeyPath<StorageValues<Value>.Type, StorageValues<Value>>,
    value: Value) where Value: RawRepresentable, Value.RawValue == String {
      let storageValue = StorageValues.self[keyPath: keyPath]

      let rawValue = value.rawValue

      set(rawValue, forKey: storageValue.key)
    }

  /// Returns the `RawRepresentable` value associated with the specified key path.
  ///
  /// - Important: Unsuccessful raw value initialization will lead to a runtime crash.
  /// Furthermore if no string value is associated with the specified key path,
  /// returns the default value stored in the `StorageValues` instance resolves to.
  ///
  /// - Parameter keyPath: The key path to the `StorageValues` instance.
  /// - Returns: The `RawRepresentable` value associated with the specified key path.
  func RawRepresentableType<Value>(
    _ keyPath: KeyPath<StorageValues<Value>.Type, StorageValues<Value>>)
  -> Value where Value: RawRepresentable, Value.RawValue == String {
    let storageValue = StorageValues.self[keyPath: keyPath]

    guard let rawValue = string(forKey: storageValue.key) else { return storageValue.defaultValue }

    return Value(rawValue: rawValue)!
  }

  /// Sets the value of the specified key path.
  /// - Parameters:
  ///   - keyPath: The key path to the `StorageValues` instance.
  ///   - value: The `RawRepresentable` value to store in the defaults database.
  func setRawRepresentable<Value>(
    _ keyPath: KeyPath<StorageValues<Value>.Type, StorageValues<Value>>,
    value: Value) where Value: RawRepresentable, Value.RawValue == Int {
      let storageValue = StorageValues.self[keyPath: keyPath]

      let rawValue = value.rawValue

      set(rawValue, forKey: storageValue.key)
    }

  /// Returns the `RawRepresentable` value associated with the specified key path.
  ///
  /// - Important: Unsuccessful raw value initialization will lead to a runtime crash.
  /// Furthermore if no string value is associated with the specified key path,
  /// returns the default value stored in the `StorageValues` instance key path resolves to.
  ///
  /// - Parameter keyPath: The key path to the `StorageValues` instance.
  /// - Returns: The `RawRepresentable` value associated with the specified key path.
  func RawRepresentableType<Value>(
    _ keyPath: KeyPath<StorageValues<Value>.Type, StorageValues<Value>>)
  -> Value where Value: RawRepresentable, Value.RawValue == Int {
    let storageValue = StorageValues.self[keyPath: keyPath]

    guard
      let object = object(forKey: storageValue.key),
      let rawValue = object as? Int
    else { return storageValue.defaultValue }

    return Value(rawValue: rawValue)!
  }
}
