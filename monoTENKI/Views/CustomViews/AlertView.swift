//
//  AlertView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/6/25 at 11:42 PM.
//

import SwiftUI

struct AlertView: View {
    @Binding var show: Bool
    let title: String
    let message: String
    let actionMessage: String
    
    var body: some View {
        VStack {
            Text(title)
            Text(message)
            Text(actionMessage)
            Divider()
                .frame(height: 2)
                .background(.white)
            HStack {
                Button {
                    show = false
                } label: {
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
    AlertView(show: .constant(true), title: "Error", message: "An Error occurred", actionMessage: "TAP TO RETRY")
}
