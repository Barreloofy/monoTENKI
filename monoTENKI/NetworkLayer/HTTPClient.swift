//
//  HTTPClient.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/18/25 at 2:34 PM.
//

import Foundation
import os
/// HTTPClient with custom decoding capability
struct HTTPClient {
  let url: URL
  let decoder: JSONDecoder

  let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "HTTPClient")

  init(url: URL, decoder: JSONDecoder = JSONDecoder()) {
    self.url = url
    self.decoder = decoder
  }

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
