//
//  APIClient.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 7:32 PM.
//

import Foundation
import OSLog

private let logger = Logger(subsystem: "com.monoTENKI.APIClient", category: "Error")

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
            logger.error("\(APIError.urlError)")
            throw APIError.urlError
        }
        
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "days", value: "3"),
        ]
        
        guard let url = components.url else {
            logger.error("\(APIError.urlError)")
            throw APIError.urlError
        }
        
        return url
    }
    
    static func fetch<T: Decodable>(service: Service, forType type: T.Type, query: String) async throws -> T {
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
    }
}


extension APIClient {
    private enum APIError: Error, LocalizedError {
        case urlError
        case typeError
        
        var errorDescription: String? {
            switch self {
            case .urlError:
              return "Error, invalid URL"
            case .typeError:
              return "Error, provided type for generic 'T' is not Weather or [Location] type"
            }
        }
    }
}
