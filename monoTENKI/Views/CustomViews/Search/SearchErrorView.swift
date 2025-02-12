//
//  SearchErrorView.swift
//  monoTENKI
//
//  Created by Barreloofy on 2/12/25 at 2:16 PM.
//

import SwiftUI

struct SearchErrorView: View {
    let text: String
    let withButton: Bool
    let action: () -> Void
    
    init(_ text: String, _ withButton: Bool, _ action: @escaping () -> Void = {}) {
        self.text = text
        self.withButton = withButton
        self.action = action
    }
    
    var body: some View {
        Text(text)
            .font(.system(.title3, design: .serif, weight: .bold))
            .lineLimit(2)
            .minimumScaleFactor(0.8)
            .multilineTextAlignment(.center)
            .padding(.top, 25)
        if withButton {
            Button {
                action()
            } label: {
                Text("TAP TO RETRY")
            }
            .buttonStyle(.monoBordered)
            .font(.system(.headline, design: .serif, weight: .bold))
        }
    }
}
