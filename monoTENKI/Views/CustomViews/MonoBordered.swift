//
//  MonoBordered.swift
//  monoTENKI
//
//  Created by Barreloofy on 2/7/25 at 7:31 PM.
//

import SwiftUI

struct MonoBordered: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(5)
            .foregroundStyle(.black)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 1.25 : 1.0)
            .animation(.snappy, value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == MonoBordered {
    static var monoBordered: MonoBordered {
        return MonoBordered()
    }
}
