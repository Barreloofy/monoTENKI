//
//  URLProvider.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 1:04 AM.
//

import Foundation
/// Protocol for constructing URLs, intended as an interface to build and retrive URLs for the HTTP protocol
protocol URLProvider {
  /// Constructs URL from URLComponents. and the provided values for 'host', 'path' and 'parameters'.
  /// - Parameters:
  ///   - host: host component of an URL, see URLComponents.host for more documentation.
  ///   - path: path component of an URL, see URLComponents.path for more documentation.
  ///   - queryItems: query component of an URL, dictionary of type [String: String?], see URLComponents.queryItems for more documentation.
  /// - Returns:
  /// A URL if construction succeeded else throws an URLError.badURL
  func constructURL(host: String, path: String, queryItems: [String: String?]) throws -> URL
  /// Provides a simple interface to retrive an URL.
  func provideURL() throws -> URL
  /// Provides a comprehensive interface to retrive a dictionary of URLs, allows to construct complex API calls with multiple API endpoints as one call.
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
