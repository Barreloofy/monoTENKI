//
// Date+CompareDateComponent.swift
// monoTENKI
//
// Created by Barreloofy on 7/3/25 at 9:13 PM
//

import Foundation

extension Date {
  func compareDateComponent(_ component: Calendar.Component, with date: Date) -> Bool {
    var calendar = Calendar.current

    calendar.timeZone = .init(abbreviation: "UTC")!

    return calendar.component(component, from: self) == calendar.component(component, from: date)
  }
}
