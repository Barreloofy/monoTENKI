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
    @State private var selected = false
    @EnvironmentObject private var unitData: UnitData
    
    enum UnitType: String {
        case temperature
    }
    
    init(unitType: UnitType, unitSymbol: String = "") {
        self.unitType = unitType
        self.unitSymbol = unitSymbol
    }
    
    private var typeName: String {
        return unitType.rawValue
    }
    
    private var firstUnit: String {
        return "C"
    }
    
    private var secondUnit: String {
        return "F"
    }
    
    var body: some View {
        ZStack {
            HStack {
                Text(typeName + ":")
                Spacer()
            }
            HStack {
                Text(firstUnit + unitSymbol)
                    .foregroundStyle(selected == false ? .white : .gray)
                    .overlay(alignment: .bottom) {
                        selected == false
                        ?
                        Rectangle()
                            .frame(height: 2)
                        :
                        nil
                    }
                    .onTapGesture {
                        selected = false
                    }
            }
            HStack {
                Spacer()
                Text(secondUnit + unitSymbol)
                    .foregroundStyle(selected == true ? .white : .gray)
                    .overlay(alignment: .bottom) {
                        selected == true
                        ?
                        Rectangle()
                            .frame(height: 2)
                        :
                        nil
                    }
                    .onTapGesture {
                        selected = true
                    }
            }
        }
        .font(.system(.body, design: .serif, weight: .bold))
        .padding(.vertical, 5)
        .onChange(of: selected) {
            if unitType == .temperature {
                unitData.temperature = selected == false ? .celsius : .fahrenheit
            }
        }
        .onAppear {
            if unitType == .temperature {
                selected = unitData.temperature == .celsius ? false : true
            }        }
    }
}

#Preview {
    UnitRow(unitType: .temperature, unitSymbol: "\u{00B0}")
        .environmentObject(UnitData())
}