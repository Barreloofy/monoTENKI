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
                    Text("X")
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            HStack {
                Text("UNITS")
                Spacer()
            }
            .font(.system(.headline, design: .serif, weight: .bold))
            UnitRow(unitType: .temperature, unitSymbol: "\u{00B0}")
            UnitRow(unitType: .clock)
            Spacer()
        }
        .font(.system(.title, design: .serif, weight: .bold))
        .foregroundStyle(.white)
        .padding()
        .background(.black)
    }
}

#Preview {
    SettingsView()
}
