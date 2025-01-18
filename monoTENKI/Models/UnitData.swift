//
//  UnitData.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/2/25 at 8:59 PM.
//

import Foundation

@MainActor
final class UnitData: ObservableObject {
    @Published var temperature: TemperatureUnits = UserDefaults.standard.temperatureUnits(forKey: "temperature") {
        didSet {
            UserDefaults.standard.set(temperature.rawValue, forKey: "temperature")
        }
    }
    @Published var speed: SpeedUnits = UserDefaults.standard.speedUnits(for: "speed") {
        didSet {
            UserDefaults.standard.set(speed.rawValue, forKey: "speed")
        }
    }
    
    enum TemperatureUnits: String {
        case celsius
        case fahrenheit
    }
    
    enum SpeedUnits: String {
        case milesPerHour
        case kilometersPerHour
    }
}

extension UserDefaults {
    func temperatureUnits(forKey key: String) -> UnitData.TemperatureUnits {
        guard let rawValue = self.string(forKey: "temperature") else { return .celsius }
        return rawValue == UnitData.TemperatureUnits.celsius.rawValue ? .celsius : .fahrenheit
    }
    
    func speedUnits(for key: String) -> UnitData.SpeedUnits {
        guard let rawValue = self.string(forKey: "speed") else { return .kilometersPerHour }
        return rawValue == UnitData.SpeedUnits.kilometersPerHour.rawValue ? .kilometersPerHour : .milesPerHour
    }
}
