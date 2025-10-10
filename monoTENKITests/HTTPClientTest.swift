//
// HTTPClientTest.swift
// monoTENKI
//
// Created by Barreloofy on 8/5/25 at 5:26 PM
//

import Testing
import Foundation
@testable import monoTENKI

// The following Swift tests aim to validate the correctness of `HTTPClient`.
// In order to create reliable tests, it's important to have complete and predictable control
// over request and response, thus the additional setup of `MockURLProtocol` and `MockResponse`.
// The former is a class inherited from `URLProtocol`,
// an abstract class that handles the loading of protocol-specific URL data,
// simply put, it provides an interface for handling requests and returning responses.
// The latter, `MockResponse`, is a container for the custom response provided to `MockURLProtocol`.

struct Person: Codable {
  let name: String
  let age: Int
  let isRetired: Bool
}

struct MockResponse {
  let statusCode: Int
  let body: Data
}

final class MockURLProtocol: URLProtocol {
  static func register(for url: URL, with response: MockResponse, requestValidator: @escaping (URLRequest) -> Bool) {
    self.requestURL = url
    self.validator = requestValidator
    self.response = response
  }

  nonisolated(unsafe) private static var requestURL: URL?
  nonisolated(unsafe) private static var validator: ((URLRequest) -> Bool)?
  nonisolated(unsafe) private static var response: MockResponse?

  override class func canInit(with task: URLSessionTask) -> Bool {
    true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    request
  }

  override func startLoading() {
    guard let client = client,
          let requestURL = Self.requestURL,
          let response = Self.response,
          let validator = Self.validator
    else {
      Issue.record("Not able to perfom URL Request")
      return
    }

    #expect(validator(request))

    guard let httpResponse = HTTPURLResponse(
      url: requestURL,
      statusCode: response.statusCode,
      httpVersion: nil,
      headerFields: nil)
    else {
      Issue.record("Not able to create an HTTPURLResponse")
      return
    }

    client.urlProtocol(self, didReceive: httpResponse, cacheStoragePolicy: .notAllowed)
    client.urlProtocol(self, didLoad: response.body)
    client.urlProtocolDidFinishLoading(self)
  }

  override func stopLoading() {}
}


@Suite(.serialized)
struct HTTPClientTest {
  static let mockSession: URLSession = {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: configuration)
  }()
  static let mockURL = URL(string: "https://httpclient-test.monotenki")!


  struct HTTPClientResponseTest {
    let mockResponseSuccess = {
      let person = Person(name: "George", age: 35, isRetired: false)
      let personData = try! JSONEncoder().encode(person)
      return MockResponse(statusCode: 200, body: personData)
    }()
    let mockResponseFailure = {
      let person = Person(name: "George", age: 35, isRetired: false)
      let personData = try! JSONEncoder().encode(person)
      return MockResponse(statusCode: 404, body: personData)
    }()

    @Test("Validate HTTPClient fetch() succeeds")
    func validateSuccessfulResponse() async throws {
      let client = HTTPClient(url: mockURL, session: mockSession)

      MockURLProtocol.register(
        for: mockURL,
        with: mockResponseSuccess,
        requestValidator: { request in
          request.url == mockURL
        })

      await #expect(throws: Never.self) {
        try await client.fetch() as Person
      }
    }

    @Test("Validate HTTPClient fetch() fails")
    func validateFailureResponse() async throws {
      let client = HTTPClient(url: mockURL, session: mockSession)

      MockURLProtocol.register(
        for: mockURL,
        with: mockResponseFailure,
        requestValidator: { request in
          request.url == mockURL
        })

      await #expect(throws: URLError.init(.badServerResponse)) {
        try await client.fetch() as Person
      }
    }
  }


  struct HTTPClientDecoderTest {
    let mockResponseCustomDecoder = {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase

      let person = Person(name: "George", age: 35, isRetired: false)
      let personData = try! encoder.encode(person)
      return MockResponse(statusCode: 200, body: personData)
    }()
    let customDecoder = {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return decoder
    }()

    @Test("Validate HTTPClient uses and succeeds with correct decoder")
    func validateSuccessfulCustomDecoder() async throws {
      let client = HTTPClient(url: mockURL, decoder: customDecoder, session: mockSession)

      MockURLProtocol.register(
        for: mockURL,
        with: mockResponseCustomDecoder) { request in
          request.url == mockURL
        }

      await #expect(throws: Never.self) {
        try await client.fetch() as Person
      }
    }

    @Test("Validate HTTPClient uses and fails with wrong decoder")
    func validateFailureCustomDecoder() async throws {
      let client = HTTPClient(url: mockURL, session: mockSession)

      MockURLProtocol.register(
        for: mockURL,
        with: mockResponseCustomDecoder) { request in
          request.url == mockURL
        }

      await #expect(throws: DecodingError.self) {
        try await client.fetch() as Person
      }
    }
  }
}
