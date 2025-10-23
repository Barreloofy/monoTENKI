//
// AsyncSequence+ForEach.swift
// monoTENKI
//
// Created by Barreloofy on 10/22/25 at 9:22 PM
//

extension AsyncSequence {
  /// Calls the given closure on each element in the  `AsyncSequence` in the same order as a for-await-in loop.
  /// - Parameter body: An asynchronous closure that takes an element of the `AsyncSequence` as a parameter.
  func forEach(_ body: (_ element: Element) async -> Void) async throws {
    for try await element in self {
      await body(element)
    }
  }
}


extension AsyncSequence where Failure == Never {
  /// Calls the given closure on each element in the `AsyncSequence` in the same order as a for-await-in loop.
  /// - Parameter body: An asynchronous closure that takes an element of the `AsyncSequence` as a parameter.
  func forEach(_ body: (_ element: Element) async -> Void) async {
    for await element in self {
      await body(element)
    }
  }
}
