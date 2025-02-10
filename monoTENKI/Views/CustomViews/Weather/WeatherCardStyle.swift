//
//  WeatherCardStyle.swift
//  monoTENKI
//
//  Created by Barreloofy on 2/9/25 at 8:25 PM.
//

import SwiftUI

struct WeatherCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.black.opacity(0.96))
                    .stroke(.white, lineWidth: 2)
                    .shadow(color: .white, radius: 5)
            }
    }
}

extension View {
    func weatherCardStyle() -> some View {
        return self.modifier(WeatherCardStyle())
    }
}
