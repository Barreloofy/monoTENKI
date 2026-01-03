//
//  JSONDecoder+DateDecodingStrategy.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/30/25.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
  /// The strategy that formats dates according to the "yyyy-MM-dd HH:mm" or "yyyy-MM-dd" format.
  nonisolated
  static let weatherAPIDateStrategy: Self = {
    .custom { decoder in
      let container = try decoder.singleValueContainer()
      var dateAsString = try container.decode(String.self)
      dateAsString.append(":00")

      do {
        return try Date(dateAsString, strategy: .iso8601
          .year()
          .month()
          .day()
          .dateTimeSeparator(.space)
          .time(includingFractionalSeconds: false))
      } catch {
        return try Date(dateAsString, strategy: .iso8601
          .year()
          .month()
          .day())
      }
    }
  }()
}


extension JSONDecoder.DateDecodingStrategy {
  /// The strategy that formats dates according to the ISO 8601 standard, dropping the `timeZone` part.
  nonisolated
  static let iso8601UTC: Self = {
    .custom { decoder in
      let container = try decoder.singleValueContainer()
      let dateAsString = try container.decode(String.self)

      return try Date(dateAsString, strategy: .iso8601
        .year()
        .month()
        .day()
        .time(includingFractionalSeconds: false))
    }
  }()
}
