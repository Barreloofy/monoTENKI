//
// StorageValues.swift
// monoTENKI
//
// Created by Barreloofy on 10/29/25 at 11:59 AM
//

struct StorageValues<Value> {
  let key: String
  let defaultValue: Value
}


extension StorageValues where Value == Bool {
  nonisolated(unsafe)
  static let setupCompleted = StorageValues(key: "setupCompleted", defaultValue: false)

  nonisolated(unsafe)
  static let userModifiedMeasurementSystem = StorageValues(key: "userModifiedMeasurementSystem", defaultValue: false)

  nonisolated(unsafe)
  static let nightVision = StorageValues(key: "nightVision", defaultValue: false)

  nonisolated(unsafe)
  static let presentSearch = StorageValues(key: "presentSearch", defaultValue: false)
}


extension StorageValues where Value == MeasurementSystem {
  nonisolated(unsafe)
  static let measurementSystemInUse = StorageValues(key: "measurementSystemInUse", defaultValue: .metric)
}


extension StorageValues where Value == APISource {
  nonisolated(unsafe)
  static let apiSourceInUse = StorageValues(key: "apiSourceInUse", defaultValue: .weatherAPI)
}


extension StorageValues where Value == Coordinate {
  nonisolated(unsafe)
  static let location = StorageValues(key: "location", defaultValue: Coordinate())
}


extension StorageValues where Value == LocationAggregate.State {
  nonisolated(unsafe)
  static let locationAggregateState = StorageValues(key: "locationAggregateState", defaultValue: .manual)
}
