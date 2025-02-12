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
    @Binding var isLoading: Bool
    
    var body: some View {
        VStack {
            Text("UH OH, SOMETHING WENT WRONG")
                .padding(.bottom, 5)
            Button {
                weatherData.fetchWeather() { result in
                    guard case .success() = result else { return }
                    isLoading = false
                    isError = false
                    
                }
            } label: {
                Text("TAP TO RETRY")
            }
            .buttonStyle(.monoBordered)
            .padding(.bottom)
            errorImage
            Spacer()
        }
        .font(.system(.title3, design: .serif, weight: .bold))
        .foregroundStyle(.white)
        .padding(.top, 50)
        .background(Color(.black).ignoresSafeArea())
    }
    
    @ViewBuilder private var errorImage: some View {
        GeometryReader { geometry in
            Image(systemName: "cloud.fill")
                .resizable()
                .scaledToFit()
                .fontWeight(.regular)
                .frame(width: geometry.size.width * 0.50)
                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.10)
            Image(systemName: "minus")
                .resizable()
                .scaledToFit()
                .fontWeight(.regular)
                .frame(width: geometry.size.width * 0.50)
                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.25)
        }
    }
}

#Preview {
    ErrorView(isError: .constant(true), isLoading: .constant(false))
        .environmentObject(WeatherData())
}
