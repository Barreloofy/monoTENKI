//
//  URLProvider.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 1:04 AM.
//

import Foundation
// MARK: - Protocol used for constructing urls, intended as an interface to build and retrive URLs for https
protocol URLProvider {
  /// Constructs an URL from URLComponents, and the provided values for 'host', 'path' and 'parameters'
  func constructURL(host: String, path: String, parameters: [String: String?]) throws -> URL
  /// Provides a simple interface to retrive an URL
  func provideURL() throws -> URL
  /// Provides a comprehensive interface to retrive a dictionary of URLs, allows to construct complex API calls with multiple API endpoints as one call
  func provideURLs(query: String) throws -> [String: URL]
}

extension URLProvider {
  func constructURL(host: String, path: String, parameters: [String: String?]) throws -> URL {
    var components = URLComponents()

    components.scheme = "https"
    components.host = host
    components.path = path
    components.queryItems = parameters.map {
      URLQueryItem(name: $0.key, value: $0.value)
    }

    guard let url = components.url else { throw URLError(.badURL) }

    return url
  }
}
