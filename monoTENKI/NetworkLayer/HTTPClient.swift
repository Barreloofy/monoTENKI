//
//  HTTPClient.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/18/25 at 2:34 PM.
//

import Foundation
import os

/// HTTPClient with custom decoding capability.
///  
/// If no argument for parameter `decoder` was provided, the default `JSONDecoder` will be used.
struct HTTPClient {
  let url: URL
  let decoder: JSONDecoder

  private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "HTTPClient")

  init(url: URL, decoder: JSONDecoder = JSONDecoder()) {
    self.url = url
    self.decoder = decoder
  }
  
  /// Fetches data from `url`, converts response to the specified type.
  /// - Returns: A value of the specified type, which must conform to Decodable.
  func fetch<T: Decodable>() async throws -> T {
    do {
      let (data, response) = try await URLSession.shared.data(from: url)
      guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }

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
