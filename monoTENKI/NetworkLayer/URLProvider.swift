//
//  URLProvider.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 1:04 AM.
//

import Foundation
/// Protocol for constructing URLs, intended as an interface to build and retrive URLs for the HTTP protocol.
protocol URLProvider {
  /// Constructs URL from URLComponents.
  /// - Parameters:
  ///   - host: host component of an URL, see URLComponents.host for more documentation.
  ///   - path: path component of an URL, see URLComponents.path for more documentation.
  ///   - queryItems: query component of an URL, dictionary of type [String: String?], see URLComponents.queryItems for more documentation.
  /// - Returns: A URL if construction succeeded else throws an error.
  func constructURL(host: String, path: String, queryItems: [String: String?]) throws -> URL

  /// Provides a simple interface to retrive an URL.
  /// - Returns: A URL with the option to throw an error instead.
  func provideURL() throws -> URL

  /// Provides a comprehensive interface to retrive a dictionary of URLs,
  /// allows the construction of complex API calls with multiple API endpoints as one call.
  /// - Parameters:
  ///   - query: An optional query to provide.
  /// - Returns: A Dictionary of [String:URL] where string is the custom identifier and URL the constructed URL.
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
