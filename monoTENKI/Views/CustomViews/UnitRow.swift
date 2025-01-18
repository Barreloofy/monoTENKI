//
//  UnitRow.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/3/25 at 5:59 PM.
//

import SwiftUI

struct UnitRow: View {
    let unitType: UnitType
    let unitSymbol: String
    @State private var selected = true
    @EnvironmentObject private var unitData: UnitData
    
    enum UnitType: String {
        case temperature
        case speed
    }
    
    init(unitType: UnitType, unitSymbol: String = "") {
        self.unitType = unitType
        self.unitSymbol = unitSymbol
    }
    
    private var typeName: String {
        return unitType.rawValue
    }
    
    private var firstUnit: String {
        return unitType == .temperature ? "C" : "KM/H"
    }
    
    private var secondUnit: String {
        return unitType == .temperature ? "F" : "MI/H"
    }
    
    var body: some View {
        ZStack {
            HStack {
                Text(typeName + ":")
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
                case .temperature:
                    unitData.temperature = selected ? .celsius : .fahrenheit
                case .speed:
                    unitData.speed = selected ? .kilometersPerHour : .milesPerHour
            }
        }
        .onAppear {
            switch unitType {
                case .temperature:
                    selected = unitData.temperature == .celsius ? true : false
                case .speed:
                    selected = unitData.speed == .kilometersPerHour ? true : false
            }
        }
    }
    
    private func isSelected(defaultValue: Bool) -> some View {
        guard defaultValue else { return selected == false ? Rectangle().frame(height: 2) : nil }
        return selected ? Rectangle().frame(height: 2) : nil
    }
}

#Preview {
    UnitRow(unitType: .temperature, unitSymbol: "\u{00B0}")
        .environmentObject(UnitData())
}
