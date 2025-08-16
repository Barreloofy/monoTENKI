//
//  HTTPClient.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/18/25 at 2:34 PM.
//

import Foundation
import os

/// HTTP Client with custom decoding capability.
struct HTTPClient {
  let url: URL
  let decoder: JSONDecoder
  let session: URLSession

  private let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: "HTTPClient")

  /// - Parameters:
  ///   - url: The URL to retrieve data from.
  ///   - decoder: The decoder to use for decoding the response, `JSONDecoder()` is the default.
  init(url: URL, decoder: JSONDecoder = JSONDecoder(), session: URLSession = .shared) {
    self.url = url
    self.decoder = decoder
    self.session = session
  }

  /// Fetches data from `url`, converts response to an instance of `T`,
  /// where `T` must be a type conforming to `Decodable`.
  /// - Returns: An instance of `T`.
  func fetch<T: Decodable>() async throws -> T {
    do {
      let (data, response) = try await session.data(from: url)

      guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        throw URLError(.badServerResponse)
      }

      return try decoder.decode(T.self, from: data)

    } catch URLError.cancelled {
      logger.error("\(URLError(.cancelled).localizedDescription)")
      throw URLError(.cancelled)

    } catch {
      logger.error("\(error)")
      throw error
    }
  }
}
