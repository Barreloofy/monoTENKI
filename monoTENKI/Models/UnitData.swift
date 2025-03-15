//
//  UnitData.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/2/25 at 8:59 PM.
//

import Foundation

protocol Unit: RawRepresentable where RawValue == String {
  static var key: String { get }
  static var defaultValue: Self { get }
  static var optionalValue: Self { get }
}

extension UserDefaults {
  func unit<T: RawRepresentable>(forKey key: String, defaultValue: T) -> T where T.RawValue == String {
    guard let rawValue = self.string(forKey: key) else { return defaultValue }
    guard let enumValue = T(rawValue: rawValue) else { return defaultValue }
    return enumValue
  }
}

@MainActor
final class UnitData: ObservableObject {
  @Published var temperature: TemperatureUnits = UserDefaults.standard.unit(forKey: "temperature", defaultValue: .celsius) {
    didSet {
      UserDefaults.standard.set(temperature.rawValue, forKey: "temperature")
    }
  }

  @Published var speed: SpeedUnits = UserDefaults.standard.unit(forKey: "speed", defaultValue: .kilometersPerHour) {
    didSet {
      UserDefaults.standard.set(speed.rawValue, forKey: "speed")
    }
  }

  @Published var measurement: MeasurementUnits = UserDefaults.standard.unit(forKey: "measurement", defaultValue: .millimeter) {
    didSet {
      UserDefaults.standard.set(measurement.rawValue, forKey: "measurement")
    }
  }


  enum TemperatureUnits: String, Unit {
    case celsius = "C"
    case fahrenheit = "F"

    static var key: String {
      return "temperature"
    }
    static var defaultValue: UnitData.TemperatureUnits {
      return .celsius
    }
    static var optionalValue: UnitData.TemperatureUnits {
      return .fahrenheit
    }
  }


  enum SpeedUnits: String, Unit {
    case milesPerHour = "MP/H"
    case kilometersPerHour = "KM/H"

    static var key: String {
      return "speed"
    }
    static var defaultValue: UnitData.SpeedUnits {
      return .kilometersPerHour
    }
    static var optionalValue: UnitData.SpeedUnits {
      return .milesPerHour
    }
  }


  enum MeasurementUnits: String, Unit {
    case millimeter = "MM"
    case inch = "IN"

    static var key: String {
      return "measurement"
    }
    static var defaultValue: UnitData.MeasurementUnits {
      return .millimeter
    }
    static var optionalValue: UnitData.MeasurementUnits {
      return .inch
    }
  }

  func setToMetric() {
    temperature = .celsius
    speed = .kilometersPerHour
    measurement = .millimeter
  }

  func setToImperial() {
    temperature = .fahrenheit
    speed = .milesPerHour
    measurement = .inch
  }
}
