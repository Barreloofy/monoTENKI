//
//  HStackText.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/17/25 at 9:03 PM.
//

import SwiftUI

struct HStackText: View {
    let orientation: Orientation
    let text: String
    
    init(orientation: Orientation, _ text: String) {
        self.orientation = orientation
        self.text = text
    }
    
    enum Orientation {
        case left
        case right
    }
    
    private func makeBody(_ text: String, _ orientation: Orientation) -> some View {
        if orientation == .left {
            return AnyView(
                HStack {
                    Text(text)
                    Spacer()
                }
            )
        } else {
            return AnyView(
                HStack {
                    Spacer()
                    Text(text)
                }
            )
        }
    }
    
    var body: some View {
        makeBody(text, orientation)
    }
}

#Preview {
    HStackText(orientation: .right, "Hello, World!")
}
