//
// HTTPClientTest.swift
// monoTENKI
//
// Created by Barreloofy on 8/5/25 at 5:26 PM
//

import Testing
import Foundation
@testable import monoTENKI

struct Person: Codable {
  let name: String
  let age: Int
  let retired: Bool
}

struct MockResponse {
  let statusCode: Int
  let body: Data
}

class MockURLProtocol: URLProtocol {
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
  let mockSession: URLSession = {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: configuration)
  }()

  let mockURL = URL(string: "https://httpclient-test.monotenki")!

  let mockResponseSuccess = {
    let person = Person(name: "George", age: 35, retired: false)
    let personData = try! JSONEncoder().encode(person)
    return MockResponse(statusCode: 200, body: personData)
  }()

  let mockResponseFailure = {
    let person = Person(name: "George", age: 35, retired: false)
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
