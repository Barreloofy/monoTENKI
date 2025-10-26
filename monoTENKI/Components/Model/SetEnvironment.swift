//
// SetEnvironment.swift
// monoTENKI
//
// Created by Barreloofy on 9/2/25 at 6:37 PM
//

import Foundation
import SwiftData

/// Sets the value of the specified key to the specified `Codable` value.
/// - Parameters:
///   - key: The appropriate `StorageKeys` key.
///   - value: The value `key` references.
///   - store: A value of nil will use the user default store from the environment.
func setEnvironment(_ keyPath: KeyPath<String.Type, String>, value: some Codable, store: UserDefaults? = nil) {
  let store = store ?? .standard
  store.set(value, forKey: String(keyPath))
}

/// Sets the value of the specified key to the specified `Bool` value.
/// - Parameters:
///   - key: The appropriate `StorageKeys` key.
///   - value: The value `key` references.
///   - store: The user defaults store to read and write to. A value of nil will use the user default store from the environment.
func setEnvironment(_ keyPath: KeyPath<String.Type, String>, value: Bool?, store: UserDefaults? = nil) {
  let store = store ?? .standard
  store.set(value, forKey: String(keyPath))
}

/// Sets the value of the specified key to the specified `Data` value.
/// - Parameters:
///   - key: The appropriate `StorageKeys` key.
///   - value: The value `key` references.
///   - store: The user defaults store to read and write to. A value of nil will use the user default store from the environment.
func setEnvironment(_ keyPath: KeyPath<String.Type, String>, value: Data?, store: UserDefaults? = nil) {
  let store = store ?? .standard
  store.set(value, forKey: String(keyPath))
}

/// Sets the value of the specified key to the specified `Date` value.
/// - Parameters:
///   - key: The appropriate `StorageKeys` key.
///   - value: The value `key` references.
///   - store: The user defaults store to read and write to. A value of nil will use the user default store from the environment.
func setEnvironment(_ keyPath: KeyPath<String.Type, String>, value: Date?, store: UserDefaults? = nil) {
  let store = store ?? .standard
  store.set(value, forKey: String(keyPath))
}

/// Sets the value of the specified key to the specified `Double` value.
/// - Parameters:
///   - key: The appropriate `StorageKeys` key.
///   - value: The value `key` references.
///   - store: The user defaults store to read and write to. A value of nil will use the user default store from the environment.
func setEnvironment(_ keyPath: KeyPath<String.Type, String>, value: Double?, store: UserDefaults? = nil) {
  let store = store ?? .standard
  store.set(value, forKey: String(keyPath))
}

/// Sets the value of the specified key to the specified `Int` value.
/// - Parameters:
///   - key: The appropriate `StorageKeys` key.
///   - value: The value `key` references.
///   - store: The user defaults store to read and write to. A value of nil will use the user default store from the environment.
func setEnvironment(_ keyPath: KeyPath<String.Type, String>, value: Int?, store: UserDefaults? = nil) {
  let store = store ?? .standard
  store.set(value, forKey: String(keyPath))
}

/// Sets the value of the specified key to the specified `PersistentIdentifier` value.
/// - Parameters:
///   - key: The appropriate `StorageKeys` key.
///   - value: The value `key` references.
///   - store: The user defaults store to read and write to. A value of nil will use the user default store from the environment.
func setEnvironment(_ keyPath: KeyPath<String.Type, String>, value: PersistentIdentifier?, store: UserDefaults? = nil) {
  let store = store ?? .standard
  store.set(value, forKey: String(keyPath))
}

/// Sets the value of the specified key to the specified `String` value.
/// - Parameters:
///   - key: The appropriate `StorageKeys` key.
///   - value: The value `key` references.
///   - store: The user defaults store to read and write to. A value of nil will use the user default store from the environment.
func setEnvironment(_ keyPath: KeyPath<String.Type, String>, value: String?, store: UserDefaults? = nil) {
  let store = store ?? .standard
  store.set(value, forKey: String(keyPath))
}

/// Sets the value of the specified key to the specified `URL` value.
/// - Parameters:
///   - key: The appropriate `StorageKeys` key.
///   - value: The value `key` references.
///   - store: The user defaults store to read and write to. A value of nil will use the user default store from the environment.
func setEnvironment(_ keyPath: KeyPath<String.Type, String>, value: URL?, store: UserDefaults? = nil) {
  let store = store ?? .standard
  store.set(value, forKey: String(keyPath))
}

/// Sets the value of the specified key to the specified value, where `value` conforms to `RawRepresentable` and `RawValue` is of type `Int`.
/// - Parameters:
///   - key: The appropriate `StorageKeys` key.
///   - value: The value `key` references.
///   - store: The user defaults store to read and write to. A value of nil will use the user default store from the environment.
func setEnvironment<R>(_ keyPath: KeyPath<String.Type, String>, value: R?, store: UserDefaults? = nil) where R: RawRepresentable, R.RawValue == Int {
  let store = store ?? .standard
  store.set(value?.rawValue, forKey: String(keyPath))
}

/// Sets the value of the specified key to the specified value, where `value` conforms to `RawRepresentable` and `RawValue` is of type `String`.
/// - Parameters:
///   - key: The appropriate `StorageKeys` key.
///   - value: The value `key` references.
///   - store: The user defaults store to read and write to. A value of nil will use the user default store from the environment.
func setEnvironment<R>(_ keyPath: KeyPath<String.Type, String>, value: R?, store: UserDefaults? = nil) where R: RawRepresentable, R.RawValue == String {
  let store = store ?? .standard
  store.set(value?.rawValue, forKey: String(keyPath))
}
