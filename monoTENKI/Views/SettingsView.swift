//
//  SettingsView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 5:29 PM.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            NavigationBar
            
            UnitBlock
            
            TipsBlock
            
            Spacer()
        }
        .foregroundStyle(.white)
        .padding()
        .background(.black)
    }
    
    
    @ViewBuilder private var NavigationBar: some View {
        ZStack {
            Text("Settings")
            
            HStackContent(orientation: .trailing) {
                Button("X") {
                    dismiss()
                }
            }
        }
        .font(.system(.title, design: .serif, weight: .bold))
    }
    
    
    @ViewBuilder private var UnitBlock: some View {
        HStackContent(orientation: .leading) {
            Text("UNITS")
                .font(.system(.headline, design: .serif, weight: .bold))
        }
        
        UnitRow(unitType: UnitData.TemperatureUnits.self, unitSymbol: "\u{00B0}")
        
        UnitRow(unitType: UnitData.SpeedUnits.self)
        
        UnitRow(unitType: UnitData.MeasurementUnits.self)
        
        HStackContent(orientation: .leading) {
            Text("TIPS")
                .font(.system(.headline, design: .serif, weight: .bold))
                .padding(.top, 20)
        }
    }
    
    
    @ViewBuilder private var TipsBlock: some View {
        HStackContent(orientation: .leading) {
            Text("Pressing on the weather icon displays additional weather details.")
                .tipsStyle()
        }
        
        HStackContent(orientation: .leading) {
            Text("Pressing on the current location's name opens the search page.")
                .tipsStyle()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UnitData())
}
