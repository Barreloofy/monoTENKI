//
// AppStorage+KeyPath.swift
// monoTENKI
//
// Created by Barreloofy on 10/29/25 at 12:00 PM
//

import SwiftUI
import SwiftData

extension AppStorage where Value: RawRepresentable, Value.RawValue == Int {
  /// Creates a property that can read and write to an `Int` user default, transforming that to `RawRepresentable` data type.
  /// - Parameter keyPath: The key path to the `StorageValues` instance.
  init(_ keyPath: KeyPath<StorageValues<Value>.Type, StorageValues<Value>>) {
    let storageValue = StorageValues.self[keyPath: keyPath]
    self.init(wrappedValue: storageValue.defaultValue, storageValue.key)
  }
}


extension AppStorage where Value: RawRepresentable, Value.RawValue == String {
  /// Creates a property that can read and write to a `String` user default, transforming that to `RawRepresentable` data type.
  /// - Parameter keyPath: The key path to the `StorageValues` instance.
  init(_ keyPath: KeyPath<StorageValues<Value>.Type, StorageValues<Value>>) {
    let storageValue = StorageValues.self[keyPath: keyPath]
    self.init(wrappedValue: storageValue.defaultValue, storageValue.key)
  }
}


extension AppStorage where Value == Bool {
  /// Creates a property that can read and write to a `Bool` user default.
  /// - Parameter keyPath: The key path to the `StorageValues` instance.
  init(_ keyPath: KeyPath<StorageValues<Value>.Type, StorageValues<Value>>) {
    let storageValue = StorageValues.self[keyPath: keyPath]
    self.init(wrappedValue: storageValue.defaultValue, storageValue.key)
  }
}


extension AppStorage where Value == Data {
  /// Creates a property that can read and write to a user default as `Data`.
  /// - Parameter keyPath: The key path to the `StorageValues` instance.
  init(_ keyPath: KeyPath<StorageValues<Value>.Type, StorageValues<Value>>) {
    let storageValue = StorageValues.self[keyPath: keyPath]
    self.init(wrappedValue: storageValue.defaultValue, storageValue.key)
  }
}


extension AppStorage where Value == Date {
  /// Creates a property that can read and write to a `Date` user default.
  /// - Parameter keyPath: The key path to the `StorageValues` instance.
  init(_ keyPath: KeyPath<StorageValues<Value>.Type, StorageValues<Value>>) {
    let storageValue = StorageValues.self[keyPath: keyPath]
    self.init(wrappedValue: storageValue.defaultValue, storageValue.key)
  }
}


extension AppStorage where Value == Double {
  /// Creates a property that can read and write to a `Double` user default.
  /// - Parameter keyPath: The key path to the `StorageValues` instance.
  init(_ keyPath: KeyPath<StorageValues<Value>.Type, StorageValues<Value>>) {
    let storageValue = StorageValues.self[keyPath: keyPath]
    self.init(wrappedValue: storageValue.defaultValue, storageValue.key)
  }
}


extension AppStorage where Value == Int {
  /// Creates a property that can read and write to an `Int` user default.
  /// - Parameter keyPath: The key path to the `StorageValues` instance.
  init(_ keyPath: KeyPath<StorageValues<Value>.Type, StorageValues<Value>>) {
    let storageValue = StorageValues.self[keyPath: keyPath]
    self.init(wrappedValue: storageValue.defaultValue, storageValue.key)
  }
}


extension AppStorage where Value == PersistentIdentifier {
  /// Creates a property that can read and write to a user default as data via `PersistentIdentifier`.
  /// - Parameter keyPath: The key path to the `StorageValues` instance.
  init(_ keyPath: KeyPath<StorageValues<Value>.Type, StorageValues<Value>>) {
    let storageValue = StorageValues.self[keyPath: keyPath]
    self.init(wrappedValue: storageValue.defaultValue, storageValue.key)
  }
}


extension AppStorage where Value == String {
  /// Creates a property that can read and write to a `String` user default.
  /// - Parameter keyPath: The key path to the `StorageValues` instance.
  init(_ keyPath: KeyPath<StorageValues<Value>.Type, StorageValues<Value>>) {
    let storageValue = StorageValues.self[keyPath: keyPath]
    self.init(wrappedValue: storageValue.defaultValue, storageValue.key)
  }
}


extension AppStorage where Value == URL {
  /// Creates a property that can read and write to a `URL` user default.
  /// - Parameter keyPath: The key path to the `StorageValues` instance.
  init(_ keyPath: KeyPath<StorageValues<Value>.Type, StorageValues<Value>>) {
    let storageValue = StorageValues.self[keyPath: keyPath]
    self.init(wrappedValue: storageValue.defaultValue, storageValue.key)
  }
}
