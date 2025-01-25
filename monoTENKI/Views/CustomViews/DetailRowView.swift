//
//  DetailRowView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/25/25 at 10:13 PM.
//

import SwiftUI

struct DetailRowView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .frame(height: 2)
        }
    }
}
