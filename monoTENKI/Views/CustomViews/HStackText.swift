//
//  HStackText.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/17/25 at 9:03 PM.
//

import SwiftUI

struct HStackText: View {
    let alignment: HorizontalAlignment
    let text: String
    
    init(orientation: HorizontalAlignment, _ text: String) {
        self.text = text
        self.alignment = orientation
    }
    
    var body: some View {
        HStack {
            if alignment == .leading {
                Text(text)
                Spacer()
            } else {
                Spacer()
                Text(text)
            }
        }
    }
}
