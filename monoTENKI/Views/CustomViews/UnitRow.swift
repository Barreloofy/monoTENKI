//
//  UnitRow.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/3/25 at 5:59 PM.
//

import SwiftUI

struct UnitRow<U: Unit>: View {
    let unitType: U.Type
    let unitSymbol: String
    @State private var selected = true
    @EnvironmentObject private var unitData: UnitData
    
    enum UnitType: String {
        case temperature
        case speed
    }
    
    init(unitType: U.Type, unitSymbol: String = "") {
        self.unitType = unitType
        self.unitSymbol = unitSymbol
    }
    
    private var firstUnit: String {
        return unitType.defaultValue.rawValue
    }
    
    private var secondUnit: String {
        return unitType.optionalValue.rawValue
    }
    
    var body: some View {
        ZStack {
            HStack {
                Text(unitType.key + ":")
                Spacer()
            }
            HStack {
                Text(firstUnit + unitSymbol)
                    .foregroundStyle(selected ? .white : .gray)
                    .overlay(alignment: .bottom) {
                        isSelected(defaultValue: true)
                    }
                    .onTapGesture {
                        selected = true
                    }
            }
            HStack {
                Spacer()
                Text(secondUnit + unitSymbol)
                    .foregroundStyle(selected == false ? .white : .gray)
                    .overlay(alignment: .bottom) {
                        isSelected(defaultValue: false)
                    }
                    .onTapGesture {
                        selected = false
                    }
            }
        }
        .font(.system(.body, design: .serif, weight: .bold))
        .padding(.vertical, 5)
        .onChange(of: selected) {
            
            switch unitType {
                case is UnitData.TemperatureUnits.Type:
                    unitData.temperature = selected ? .celsius : .fahrenheit
                case is UnitData.SpeedUnits.Type:
                    unitData.speed = selected ? .kilometersPerHour : .milesPerHour
                case is UnitData.MeasurementUnits.Type:
                    unitData.measurement = selected ? .millimeter : .inch
                default:
                    fatalError("unknown type \(unitType)")
            }
        }
        .onAppear {
            switch unitType {
                case is UnitData.TemperatureUnits.Type:
                    selected = unitData.temperature == .defaultValue ? true : false
                case is UnitData.SpeedUnits.Type:
                    selected = unitData.speed == .defaultValue ? true : false
                case is UnitData.MeasurementUnits.Type:
                    selected = unitData.measurement == .defaultValue ? true : false
                default:
                    fatalError("unknown type \(unitType)")
            }
        }
    }
    
    private func isSelected(defaultValue: Bool) -> some View {
        guard defaultValue else { return selected == false ? Rectangle().frame(height: 2) : nil }
        return selected ? Rectangle().frame(height: 2) : nil
    }
}

#Preview {
    UnitRow(unitType: UnitData.TemperatureUnits.self, unitSymbol: "\u{00B0}")
        .environmentObject(UnitData())
}
