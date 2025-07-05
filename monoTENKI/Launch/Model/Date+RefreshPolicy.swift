//
// Date+RefreshPolicy.swift
// monoTENKI
//
// Created by Barreloofy on 6/27/25 at 12:10 AM
//

import Foundation

extension Date {
  static var nextRefreshDate: Date { .init(timeInterval: 900, since: .now) }

  var nextRefreshDate: Date { .init(timeInterval: 900, since: .now) }
}
