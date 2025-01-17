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
            ZStack {
                Text("Settings")
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Text("X")
                    }
                }
            }
            .font(.system(.title, design: .serif, weight: .bold))
            
            HStackText(orientation: .leading, "UNITS")
                .font(.system(.headline, design: .serif, weight: .bold))
            
            UnitRow(unitType: .temperature, unitSymbol: "\u{00B0}")
            
            UnitRow(unitType: .speed)
            
            HStackText(orientation: .leading, "TIPS")
                .font(.system(.headline, design: .serif, weight: .bold))
                .padding(.top, 20)
            
            HStackText(orientation: .leading, "Pressing on the weather icon displays additional weather details.")
                .font(.system(.footnote, design: .serif, weight: .bold))
                .padding(.vertical, 5)
            
            HStackText(orientation: .leading, "Pressing on the current location's name opens the search page.")
                .font(.system(.footnote, design: .serif, weight: .bold))
            
            Spacer()
        }
        .foregroundStyle(.white)
        .padding()
        .background(.black)
    }
}

#Preview {
    SettingsView()
        .environmentObject(UnitData())
}
