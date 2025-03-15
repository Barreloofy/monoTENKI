//
//  Logger.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/14/25 at 2:20 PM.
//

import Foundation
import os

extension Logger {
  static private let subsystem = Bundle.main.bundleIdentifier!

  static let networking = Logger(subsystem: subsystem, category: "networking")

  static let filesystem = Logger(subsystem: subsystem, category: "filesystem")
}
