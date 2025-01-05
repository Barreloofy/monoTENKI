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
    
    enum TemperatureUnits: String {
        case celsius
        case fahrenheit
    }
}

extension UserDefaults {
    func temperatureUnits(forKey key: String) -> UnitData.TemperatureUnits {
        guard let rawValue = self.string(forKey: "temperature") else { return .celsius }
        return rawValue == UnitData.TemperatureUnits.celsius.rawValue ? .celsius : .fahrenheit
    }
}
