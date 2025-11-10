//
// StorageValues.swift
// monoTENKI
//
// Created by Barreloofy on 10/29/25 at 11:59 AM
//

struct StorageValues<Value> where Value: Sendable {
  let key: String
  let defaultValue: Value
}


extension StorageValues where Value == Bool {
  static let setupCompleted = StorageValues(key: "setupCompleted", defaultValue: false)

  static let nightVision = StorageValues(key: "nightVision", defaultValue: false)

  static let presentSearch = StorageValues(key: "presentSearch", defaultValue: false)
}


extension StorageValues where Value == MeasurementSystem {
  static let measurementSystemInUse = StorageValues(key: "measurementSystemInUse", defaultValue: .metric)
}


extension StorageValues where Value == APISource {
  static let apiSourceInUse = StorageValues(key: "apiSourceInUse", defaultValue: .weatherAPI)
}


extension StorageValues where Value == Coordinate {
  static let location = StorageValues(key: "location", defaultValue: Coordinate())
}


extension StorageValues where Value == LocationAggregate.State {
  static let locationAggregateState = StorageValues(key: "locationAggregateState", defaultValue: .manual)
}
