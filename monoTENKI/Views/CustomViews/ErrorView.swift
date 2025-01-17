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
                VStack {
                    Text("UH OH, SOMETHING WENT WRONG")
                        .padding(.bottom)
                    Button {
                        weatherData.fetchWeather() { result in
                            switch result {
                                case .success():
                                    isError = false
                                case .failure(_):
                                    return
                            }
                        }
                    } label: {
                        Text("TAP TO RETRY")
                    }
                }
                .padding(.vertical, 50)
                Image(systemName: "cloud.fill")
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.regular)
                    .padding(.horizontal, 100)
                Image(systemName: "minus")
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.regular)
                    .padding(.horizontal, 150)
                Spacer()
            }
            .font(.system(.title3, design: .serif, weight: .bold))
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    ErrorView(isError: .constant(true))
        .environmentObject(WeatherData())
}
