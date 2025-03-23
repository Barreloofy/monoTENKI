//
//  HTTPClient.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/18/25 at 2:34 PM.
//

import Foundation
/// Generic HTTPClient with decoding capability
struct HTTPClient {
  let urlProvider: URLProvider
  let decoder: JSONDecoder

  init(urlProvider: URLProvider, decoder: JSONDecoder = JSONDecoder()) {
    self.urlProvider = urlProvider
    self.decoder = decoder
  }

  func fetch<T: Decodable>() async throws -> T {
    let (data, response) = try await URLSession.shared.data(from: urlProvider.constructURL())

    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      throw Errors.badRequest("In: func fetch<T: Decodable>(from url: URL, with decoder: JSONDecoder) async throws -> T")
    }

    return try decoder.decode(T.self, from: data)
  }
}

// MARK: - Errors
extension HTTPClient {
  enum Errors: Error {
    case badRequest(String = "")
  }
}
