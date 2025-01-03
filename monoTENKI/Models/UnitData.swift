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
    @Published var clock: ClockUnits = UserDefaults.standard.clockUnits(forKey: "clock") {
        didSet {
            UserDefaults.standard.set(clock.rawValue, forKey: "clock")
        }
    }
    
    enum TemperatureUnits: String {
        case celsius
        case fahrenheit
    }
    
    enum ClockUnits: String {
        case H12
        case H24
    }
}

extension UserDefaults {
    func temperatureUnits(forKey key: String) -> UnitData.TemperatureUnits {
        guard let rawValue = self.string(forKey: "temperature") else { return .celsius }
        return rawValue == UnitData.TemperatureUnits.celsius.rawValue ? .celsius : .fahrenheit
    }
    
    func clockUnits(forKey key: String) -> UnitData.ClockUnits {
        guard let rawValue = self.string(forKey: "clock") else { return .H24 }
        return rawValue == UnitData.ClockUnits.H24.rawValue ? .H24 : .H12
    }
}
