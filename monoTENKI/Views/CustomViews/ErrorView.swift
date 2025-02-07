//
//  ErrorView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/8/25 at 1:48 AM.
//

import SwiftUI

struct ErrorView: View {
    @EnvironmentObject private var weatherData: WeatherData
    @Binding var isError: Bool
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            VStack {
                
                Text("UH OH, SOMETHING WENT WRONG")
                    .padding(.bottom, 5)
                
                Button {
                    weatherData.fetchWeather() { result in
                        guard case .success() = result else { return }
                        isError = false
                    }
                } label: {
                    Text("TAP TO RETRY")
                }
                .buttonStyle(.monoBordered)
                .padding(.bottom)
                ErrorImage(systemName: "cloud.fill", 100)
                ErrorImage(systemName: "minus", 150)
                Spacer()
            }
            .font(.system(.title3, design: .serif, weight: .bold))
            .foregroundStyle(.white)
            .padding(.top, 50)
        }
    }
}


struct ErrorImage: View {
    let systemName: String
    let horizontalPadding: CGFloat
    
    init(systemName: String, _ horizontalPadding: CGFloat) {
        self.systemName = systemName
        self.horizontalPadding = horizontalPadding
    }
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .fontWeight(.regular)
            .padding(.horizontal, horizontalPadding)
    }
}


#Preview {
    ErrorView(isError: .constant(true))
        .environmentObject(WeatherData())
}
