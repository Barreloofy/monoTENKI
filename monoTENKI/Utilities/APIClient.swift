//
//  APIClient.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 7:32 PM.
//

import Foundation
import os

struct APIClient {
  private static let baseURL = URL(string: "https://api.weatherapi.com/v1/")!

  private init() {}

  private static var apiKey: String {
    return Bundle.main.object(forInfoDictionaryKey: "WeatherAPI.comAPIKey") as! String
  }


  enum Service: String {
    case weather = "forecast.json"
    case location = "search.json"
  }


  static private func buildURL(_ service: Service, _ query: String) throws -> URL {
    guard var components = URLComponents(
      url: baseURL.appendingPathComponent(service.rawValue),
      resolvingAgainstBaseURL: false) else {
      throw PathError.malformedURL("In: buildURL(_ service: Service, _ query: String) throws -> URL")
    }

    components.queryItems = [
      URLQueryItem(name: "key", value: apiKey),
      URLQueryItem(name: "q", value: query),
      URLQueryItem(name: "days", value: "3"),
    ]

    guard let url = components.url else {
      throw PathError.malformedURL("In: buildURL(_ service: Service, _ query: String) throws -> URL")
    }

    return url
  }

  static func fetch<T: Decodable>(service: Service, forType type: T.Type, query: String) async throws -> T {
    do {
      let url = try buildURL(service, query)
      let (data, _) = try await URLSession.shared.data(from: url)
      let decoder = JSONDecoder()

      decoder.keyDecodingStrategy = .convertFromSnakeCase
      decoder.dateDecodingStrategy = .custom { decoder in
        let container = try decoder.singleValueContainer()
        let stringDate = try container.decode(String.self)
        let dateFormatter = DateFormatter()

        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        if let date = dateFormatter.date(from: stringDate) { return date }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: stringDate) { return date }

        throw DecodingError.dataCorruptedError(
          in: container,
          debugDescription: "Date string does not match format expected by formatter")
      }

      return try decoder.decode(T.self, from: data)
    } catch {
      Logger.networking.error("\(error)")
      throw error
    }
  }
}
