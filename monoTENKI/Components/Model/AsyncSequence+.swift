//
// AsyncSequence+.swift
// monoTENKI
//
// Created by Barreloofy on 10/22/25 at 9:22 PM
//

extension AsyncSequence {
  func forEach(_ perform: (Self.Element) async throws -> Void) async rethrows {
    for try await element in self {
      try await perform(element)
    }
  }
}
