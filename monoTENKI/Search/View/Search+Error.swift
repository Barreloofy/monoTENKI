//
//  Search+Error.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/2/25 at 2:29 PM.
//

// MARK: - Error enum for Search view. Used to conditionally handle UI error presentation
extension Search {
  enum Errors {
    case none
    case search
    case location
  }
}
