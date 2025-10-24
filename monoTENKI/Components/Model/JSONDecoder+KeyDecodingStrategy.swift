//
// JSONDecoder+KeyDecodingStrategy.swift
// monoTENKI
//
// Created by Barreloofy on 10/24/25 at 7:15 PM
//

import Foundation

extension JSONDecoder.KeyDecodingStrategy {
  struct PascalCaseCodingKey: CodingKey {
    let stringValue: String
    let intValue: Int?

    init(stringValue: String) {
      self.stringValue = stringValue.prefix(1).lowercased() + stringValue.dropFirst()
      self.intValue = nil
    }

    init?(intValue: Int) { return nil }
  }

  /// Converts JSON key from PascalCase to camelCase.
  static let convertFromPascalCase: Self = {
    .custom { keys in
      let key = keys.last!.stringValue

      return PascalCaseCodingKey(stringValue: key)
    }
  }()
}
