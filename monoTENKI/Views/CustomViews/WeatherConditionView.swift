//
//  WeatherConditionView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/17/25 at 6:43 PM.
//

import SwiftUI

struct WeatherConditionView: View {
    let condition: String
    let isDay: Bool
    
    var body: some View {
        Image(systemName: getWeatherIcon(for: condition, isDay: isDay))
            .resizable()
            .scaledToFit()
            .fontWeight(.regular)
            .shadow(color: .white, radius: 10, x: 5, y: 5)
            .padding()
    }
}

#Preview {
    WeatherConditionView(condition: "Clear", isDay: true)
}
