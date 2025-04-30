//
//  JSONDecoder+Strategies.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/30/25.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
  /// Converts a JSON String date: "yyyy-MM-dd HH:mm", "yyyy-MM-dd" to a Swift 'Date' type.
  /// Important, this Date-decoder uses a dateFormatter with the 'timeZone' property set to "UTC".
  static var WeatherApiDateDecoder: Self {
    .custom { decoder in
      let container = try decoder.singleValueContainer()
      let stringDate = try container.decode(String.self)
      let dateFormatter = DateFormatter()

      dateFormatter.timeZone = TimeZone(identifier: "UTC")
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

      if let date = dateFormatter.date(from: stringDate) { return date }
      dateFormatter.dateFormat = "yyyy-MM-dd"
      if let date = dateFormatter.date(from: stringDate) { return date }

      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Date string does not match format expected by formatter")
    }
  }
}


extension JSONDecoder.KeyDecodingStrategy {
  /// Converts JSON key from PascalCase to camelCase
  static var convertFromPascalCase: Self {
    .custom { keys in
      let key = keys.last!.stringValue

      return PascalCaseCodingKey(stringValue: key)
    }
  }
}


struct PascalCaseCodingKey: CodingKey {
  let stringValue: String
  let intValue: Int?

  init(stringValue: String) {
    self.stringValue = stringValue.prefix(1).lowercased() + stringValue.dropFirst()
    intValue = nil
  }

  init?(intValue: Int) { return nil }
}
