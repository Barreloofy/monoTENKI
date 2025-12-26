//
// DateTest.swift
// monoTENKI
//
// Created by Barreloofy on 12/26/25 at 12:36 AM
//

import Foundation
import Testing
@testable import monoTENKI

struct DateTestsForISO8601UTC {
  let json = """
  {
      "date": "2025-08-01T07:15:42+01:00"
  }
  """.data(using: .utf8)!


  let referenceDate = {
    var components = DateComponents()
    components.year = 2025
    components.month = 8
    components.day = 1
    components.hour = 7
    components.minute = 15
    components.second = 42
    components.timeZone = .gmt
    components.calendar = .current

    return components.date!
  }()


  let decoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601UTC

    return decoder
  }()


  @Test func decodeDateFromJSON() async throws {
    // Arrange
    let dictionary = try decoder.decode([String: Date].self, from: json)

    // Act
    let date = try #require(dictionary["date"])

    // Assert
    #expect(date == referenceDate)
  }


  @Test func compareDateComponents() async throws {
    // Arrange
    let dictionary = try decoder.decode([String: Date].self, from: json)
    let date = try #require(dictionary["date"])

    let components: Set<Calendar.Component> = [
      .year,
      .month,
      .day,
      .hour,
      .minute,
      .second,
    ]

    // Act & Assert
    for component in components {
      #expect(referenceDate.compareDateComponent(component, with: date))
    }
  }
}


struct DateTestsForweatherAPIDateStrategy {
  let json = """
  {
    "dateWithTime": "2025-07-31 18:33",
    "dateWithoutTime": "2025-07-31",
  }
  """.data(using: .utf8)!


  let decoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .weatherAPIDateStrategy

    return decoder
  }()


  let referenceDateWithTime = {
    var components = DateComponents()
    components.year = 2025
    components.month = 7
    components.day = 31
    components.hour = 18
    components.minute = 33
    components.timeZone = .gmt
    components.calendar = .current

    return components.date!
  }()


  let referencedateWithoutTime = {
    var components = DateComponents()
    components.year = 2025
    components.month = 7
    components.day = 31
    components.timeZone = .gmt
    components.calendar = .current

    return components.date!
  }()


  @Test func decodeDateFromJSON() async throws {
    // Arrange
    let dictionary = try decoder.decode([String: Date].self, from: json)

    // Act
    let dateWithTime = try #require(dictionary["dateWithTime"])
    let dateWithoutTime = try #require(dictionary["dateWithoutTime"])

    // Assert
    #expect(dateWithTime == referenceDateWithTime)
    #expect(dateWithoutTime == referencedateWithoutTime)
  }


  @Test func compareDateComponents() async throws {
    // Arrange
    let dictionary = try decoder.decode([String: Date].self, from: json)

    let dateWithTime = try #require(dictionary["dateWithTime"])
    let dateWithoutTime = try #require(dictionary["dateWithoutTime"])

    let components: Set<Calendar.Component> = [
      .year,
      .month,
      .day,
      .hour,
      .minute,
      .second,
    ]

    // Act & Assert
    for component in components {
      #expect(referenceDateWithTime.compareDateComponent(component, with: dateWithTime))
      #expect(referencedateWithoutTime.compareDateComponent(component, with: dateWithoutTime))
    }
  }
}
