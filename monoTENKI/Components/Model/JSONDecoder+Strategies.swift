//
//  JSONDecoder+Strategies.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/30/25.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
  /// Converts a JSON String date: "yyyy-MM-dd HH:mm", "yyyy-MM-dd" to `Date` type.
  ///
  /// > Important:
  /// Date components are `ISO 8601` but the format itself, here, is not compliant.
  ///
  /// > Important:
  /// Date-decoder uses a dateFormatter with the `timeZone` property set to UTC.
  static var weatherAPIDateStrategy: Self {
    .custom { decoder in
      let container = try decoder.singleValueContainer()
      let stringDate = try container.decode(String.self)

      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
      dateFormatter.timeZone = TimeZone(identifier: "UTC")

      if let date = dateFormatter.date(from: stringDate) { return date }
      dateFormatter.dateFormat = "yyyy-MM-dd"
      if let date = dateFormatter.date(from: stringDate) { return date }

      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Date string does not match format expected by formatter")
    }
  }
}


extension JSONDecoder.DateDecodingStrategy {
  /// Converts a JSON string date following the `ISO 8601` standard into `Date` type, with timeZone set to UTC.
  static var iso8601UTC: Self {
    .custom { decoder in
      let container = try decoder.singleValueContainer()
      let stringDate = try String(container.decode(String.self).dropLast(6))

      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
      dateFormatter.timeZone = TimeZone(identifier: "UTC")

      guard let date = dateFormatter.date(from: stringDate) else {
        throw DecodingError.dataCorruptedError(
          in: container,
          debugDescription: "Date string does not match format expected by formatter")
      }

      return date
    }
  }
}


extension JSONDecoder.KeyDecodingStrategy {
  struct PascalCaseCodingKey: CodingKey {
    let stringValue: String
    let intValue: Int?

    init(stringValue: String) {
      self.stringValue = stringValue.prefix(1).lowercased() + stringValue.dropFirst()
      intValue = nil
    }

    init?(intValue: Int) { return nil }
  }

  /// Converts JSON key from PascalCase to camelCase.
  static var convertFromPascalCase: Self {
    .custom { keys in
      let key = keys.last!.stringValue

      return PascalCaseCodingKey(stringValue: key)
    }
  }
}
