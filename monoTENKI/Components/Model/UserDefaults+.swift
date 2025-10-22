//
// UserDefaults+.swift
// monoTENKI
//
// Created by Barreloofy on 10/22/25 at 9:23 PM
//

import Foundation

extension UserDefaults {
  func set(_ value: some Codable, for key: StorageKeys) {
    let data = try? JSONEncoder().encode(value)

    set(data, forKey: key.rawValue)
  }

  func codableType<Value: Codable>(for key: StorageKeys, defaultValue: Value) -> Value {
    guard
      let data = data(forKey: key.rawValue),
      let value = try? JSONDecoder().decode(Value.self, from: data)
    else { return defaultValue }

    return value
  }
}
