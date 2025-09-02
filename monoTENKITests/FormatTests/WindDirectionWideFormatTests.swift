//
// WindDirectionWideFormatTests.swift
// monoTENKI
//
// Created by Barreloofy on 9/2/25 at 2:00 PM
//

import Testing
@testable import monoTENKI

@Suite("WindDirectionWideFormat Tests")
struct WindDirectionWideFormatTests {
  @Test(
    "Validate successful formatting",
    arguments: [
      ("n", "north"),
      ("s", "south"),
      ("e", "east"),
      ("w", "west"),
      ("ne", "northeast"),
      ("se", "southeast"),
      ("sw", "southwest"),
      ("nw", "northwest"),
      ("wnw", "west-northwest"),
      ("nnw", "north-northwest"),
      ("nne", "north-northeast"),
      ("ene", "east-northeast"),
      ("ese", "east-southeast"),
      ("sse", "south-southeast"),
      ("ssw", "south-southwest"),
      ("wsw", "west-southwest"),
    ])
  func validateSuccessfulFormatting(abbreviatedDirection: String, expected: String) async throws {
    let formatter = WindDirectionWideFormat()

    #expect(formatter.format(abbreviatedDirection) == expected)
  }

  @Test("Validate incorrect input")
  func validateIncorrectInput() async throws {
    let formatter = WindDirectionWideFormat()

    let invalidInput = "xxy"

    #expect(formatter.format(invalidInput) == invalidInput, "Invalid input is returned as is")
  }
}
