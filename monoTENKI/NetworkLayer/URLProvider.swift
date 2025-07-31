//
//  URLProvider.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 1:04 AM.
//

import Foundation

/// Protocol for constructing URLs, intended as an interface to build and retrive URLs for the `HTTP` protocol.
protocol URLProvider {
  /// Constructs `URL` from `URLComponents`.
  /// - Parameters:
  ///   - host: The host subcomponent.
  ///   - path: The path subcomponent.
  ///   - queryItems: A dictionary of `[String: String?]` that maps to an Array of `URLQueryItem`.
  /// - Throws: Up to the implementation, usually a `URLError`.
  /// - Returns: A `URL` constructed from its constituent parts.
  func constructURL(host: String, path: String, queryItems: [String: String?]) throws -> URL

  /// Provides a simple interface to retrive a `URL`.
  ///
  /// Implement this method when only one `URL` is required
  /// and its construction is straightforward.
  /// - Throws: Up to the implementation, usually a `URLError`.
  /// - Returns: `URL`.
  func provideURL() throws -> URL
  
  /// Provides a comprehensive interface to retrive a `URL`.
  ///
  /// Implement this method when the intended functionally is
  /// to retrive an aggregate of data in one call.
  ///
  /// - Parameters:
  ///   - query: An external query.
  /// - Throws: Up to the implementation, usually a `URLError`.
  /// - Returns: A dictionary of `[String: URL]` where the key is a prior defined identifier.
  func provideURLs(query: String) throws -> [String: URL]
}


extension URLProvider {
  func constructURL(host: String, path: String, queryItems: [String: String?]) throws -> URL {
    var components = URLComponents()

    components.scheme = "https"
    components.host = host
    components.path = path
    components.queryItems = queryItems.map {
      URLQueryItem(name: $0.key, value: $0.value)
    }

    guard let url = components.url else { throw URLError(.badURL) }

    return url
  }
}
