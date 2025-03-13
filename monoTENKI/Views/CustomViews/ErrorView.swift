//
//  ErrorView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/8/25 at 1:48 AM.
//

import SwiftUI

struct ErrorView: View {
    @EnvironmentObject private var weatherData: WeatherData
    @Binding var state: ViewState
    
    var body: some View {
        VStack {
            Text("UH OH, SOMETHING WENT WRONG")
                .padding(.bottom, 5)
            
            Button("TAP TO RETRY") { retryButtonAction() }
                .buttonStyle(.monoBordered)
                .padding(.bottom)
            
            errorImage
            
            Spacer()
        }
        .font(.system(.title3, design: .serif, weight: .bold))
        .foregroundStyle(.white)
        .padding(.top, 50)
        .background(Color(.black).opacity(0.98).ignoresSafeArea())
    }
    
    private var errorImage: some View {
        GeometryReader { proxy in
            let imageWidth = proxy.size.width / 2
            let height = proxy.size.height
            
            imageModifier(systemName: "cloud.fill", position: CGPoint(x: imageWidth, y: height * 0.10))
            imageModifier(systemName: "minus", position: CGPoint(x: imageWidth, y: height * 0.25))
        }
    }
    
    private func imageModifier(systemName: String, position: CGPoint) -> some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .fontWeight(.regular)
            .frame(width: position.x)
            .position(position)
    }
    
    private func retryButtonAction() {
        Task {
            guard (try? await weatherData.fetchWeather()) != nil else { return }
            state = .loaded
        }
    }
}

#Preview {
    ErrorView(state: .constant(.error))
        .environmentObject(WeatherData())
}
