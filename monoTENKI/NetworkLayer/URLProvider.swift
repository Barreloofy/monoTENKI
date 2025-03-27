//
//  URLProvider.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 1:04 AM.
//

import Foundation
/// Protocol used for constructing urls
protocol URLProvider {
  func constructURL() throws -> URL
}
