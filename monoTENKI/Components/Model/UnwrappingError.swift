//
// UnwrappingError.swift
// monoTENKI
//
// Created by Barreloofy on 9/5/25 at 3:02 PM
//

import Foundation

/// An error that indicates that optional unwrapping failed.
struct UnwrappingError: LocalizedError {
  let type: (any Any.Type)?
  let comment: String?

  /// - Parameters:
  ///   - type: The type of the value that produced nil.
  ///   - comment: "A comment describing the failure."
  init(type: (any Any.Type)? = nil, comment: String? = nil) {
    self.type = type
    self.comment = comment
  }

  var errorDescription: String? {
    if let type = type, let comment = comment {
      "Failed to unwrap optional value of type: '\(type)' with comment: \(comment)"
    } else if let type = type, comment == nil {
      "Failed to unwrap optional value of type: '\(type)'"
    } else if type == nil, let comment = comment {
      "Failed to unwrap optional value, comment: \(comment)"
    } else {
      "Failed to unwrap optional value"
    }
  }
}
