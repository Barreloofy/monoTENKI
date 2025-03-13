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
            HStackContent(orientation: .leading) {
                Text(unitType.key + ":")
            }
            UnitItem(text: firstUnit + unitSymbol, isOn: $selected, reversed: false)
            HStackContent(orientation: .trailing) {
                UnitItem(text: secondUnit + unitSymbol, isOn: $selected, reversed: true)
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
}


struct UnitItem: View {
    let text: String
    @Binding var isOn: Bool
    let reversed: Bool
    
    var isSelected: Bool {
        if reversed {
            return isOn ? false : true
        }
        else {
            return isOn ? true : false
        }
    }
    
    var body: some View {
        Text(text)
            .foregroundStyle(isSelected ? .white : .gray)
            .overlay(alignment: .bottom) {
                Spacer()
                isSelected ?
                Rectangle().frame(height: 2)
                :
                nil
            }
            .onTapGesture {
                isOn = reversed ? false : true
            }
    }
}

#Preview {
    UnitRow(unitType: UnitData.TemperatureUnits.self, unitSymbol: "\u{00B0}")
        .environmentObject(UnitData())
}
