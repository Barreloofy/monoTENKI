//
//  HTTPClient.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/18/25 at 2:34 PM.
//

import Foundation
import Combine
import os

/// HTTP Client with custom decoding capability.
struct HTTPClient<Decoder> where Decoder: TopLevelDecoder, Decoder.Input == Data {
  let url: URL
  let decoder: Decoder
  let session: URLSession

  private let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: "HTTPClient")

  /// - Parameters:
  ///   - url: The URL to retrieve data from.
  ///   - decoder: The decoder to use for decoding the response, `JSONDecoder()` is the default.
  ///   - session: The `URLSession` to use for network tasks, `shared` is the default.
  init(url: URL, decoder: Decoder = JSONDecoder(), session: URLSession = .shared) {
    self.url = url
    self.decoder = decoder
    self.session = session
  }

  /// Fetches the contents of a URL
  /// and decodes the response into an instance of `T`.
  /// - Returns: An instance of `T`.
  func fetch<T: Decodable>() async throws -> T {
    do {
      let (data, response) = try await session.data(from: url)

      guard
        let statusCode = (response as? HTTPURLResponse)?.statusCode,
        Range(200...299).contains(statusCode)
      else { throw URLError(.badServerResponse) }

      return try decoder.decode(T.self, from: data)
    } catch {
      logger.error("\(error.localizedDescription)")

      throw error
    }
  }
}
