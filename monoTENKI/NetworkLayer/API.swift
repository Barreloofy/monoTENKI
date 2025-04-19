//
//  API.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/19/25 at 5:12 PM.
//

import Foundation

protocol API {
  associatedtype Response: Decodable
  func fetch() async throws -> Response
}
