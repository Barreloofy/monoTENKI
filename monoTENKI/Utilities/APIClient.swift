//
//  APIClient.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 7:32 PM.
//

import Foundation
import OSLog

struct APIClient {
    private static let logger = Logger(subsystem: "com.monoTENKI.APIClient", category: "Error")
    private static let baseURL = URL(string: "https://api.weatherapi.com/v1/")!
    private static var apiKey: String {
        return Bundle.main.object(forInfoDictionaryKey: "WeatherAPI.comAPIKey") as! String
    }
    
    private init() {}
    
    private enum APIError: String, Error {
        case urlError = "Error, invalid URL"
        case typeError = "Error, provided type for 'T' is not Weather or [Location] type"
    }
    
    enum Service: String {
        case weather = "forecast.json"
        case location = "search.json"
    }
    
    static private func buildURL(_ service: Service, _ query: String) throws -> URL {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(service.rawValue), resolvingAgainstBaseURL: false) else {
            logger.error("\(APIError.urlError.rawValue)")
            throw APIError.urlError
        }
        components.queryItems = [URLQueryItem(name: "key", value: apiKey), URLQueryItem(name: "q", value: query), URLQueryItem(name: "days", value: "3")]
        guard let url = components.url else {
            logger.error("\(APIError.urlError.rawValue)")
            throw APIError.urlError
        }
        return url
    }
    
    static func fetch<T: Decodable>(service: Service, forType type: T.Type, _ query: String) async throws -> T {
        let url = try buildURL(service, query)
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return try decoder.decode(T.self, from: data)
    }
}
