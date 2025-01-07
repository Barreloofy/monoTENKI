//
//  AlertView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/6/25 at 11:42 PM.
//

import SwiftUI

struct AlertView: View {
    
    var body: some View {
        VStack {
            Text("Error")
            Text("An Error occurred while perfoming action")
            Divider()
                .frame(height: 2)
                .background(.white)
            HStack {
                Button {} label: {
                    Text("Okay")
                }
            }
        }
        .font(.system(.headline, design: .serif, weight: .bold))
        .foregroundStyle(.white)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}

#Preview {
    AlertView()
}
