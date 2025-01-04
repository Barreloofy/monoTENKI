//
//  WeatherView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 2:18 AM.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject private var unitData: UnitData
    @StateObject private var weatherData = WeatherData()
    @State private var sheet = false
    var body: some View {
        ScrollView {
            VStack {
                GeometryReader { geometry in
                    let screenWidth = geometry.size.width
                    let screenHeight = geometry.size.height
                    VStack {
                        Text(presentTemperature(unitData.temperature, weatherData.currentWeather.info.tempC))
                            .font(.system(.largeTitle, design: .serif, weight: .bold))
                            .onAppear {
                                weatherData.fetchWeather("Moscow")
                            }
                            .sheet(isPresented: $sheet) {
                                SettingsView()
                            }
                            .onTapGesture {
                                sheet = true
                            }
                        Image(systemName: getWeatherIcon(for: weatherData.currentWeather.info.condition.text, isDay: false))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                        Text(weatherData.currentWeather.info.condition.text)
                            .font(.system(.title, design: .serif, weight: .bold))
                    }
                    .frame(width: screenWidth * 0.66)
                    .position(CGPoint(x: screenWidth / 2, y: screenHeight / 2))
                }
                .aspectRatio(contentMode: .fit)
                HStack {
                    ForEach(weatherData.dayForecast) { day in
                        ForecastView(day: day)
                    }
                }
                .padding()
                Spacer()
            }
            .foregroundStyle(.background)
        }
        .background(.black)
    }
}

#Preview {
    WeatherView()
        .environmentObject(UnitData())
}

func presentTemperature(_ unit: UnitData.TemperatureUnits, _ tempCDouble: Double) -> String {
    let degreeSymbol = "\u{00B0}"
    if unit == .celsius {
        return String(Int(tempCDouble)) + degreeSymbol
    } else {
        let tempFInt = Int(tempCDouble * (9/5) + 32)
        return String(tempFInt) + degreeSymbol
    }
}

func getWeatherIcon(for condition: String, isDay: Bool) -> String {
    let condition = condition.trimmingCharacters(in: .whitespaces).lowercased()
    switch condition {
        case "sunny":
            return isDay ? "sun.max.fill" : "moon.fill"
        case "partly cloudy":
            return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        case "cloudy", "overcast":
            return "cloud.fill"
        case "mist", "fog":
            return "cloud.fog.fill"
        case "light drizzle" ,"patchy rain possible", "light rain", "moderate rain at times", "moderate rain", "heavy rain at times", "heavy rain":
            return "cloud.rain.fill"
        case "patchy snow possible", "light snow", "patchy light snow", "moderate snow", "heavy snow":
            return "cloud.snow.fill"
        case "patchy sleet possible", "light sleet", "moderate sleet", "light sleet showers", "moderate sleet showers":
            return "cloud.sleet.fill"
        case "patchy freezing drizzle possible", "light freezing rain", "moderate or heavy freezing rain":
            return "cloud.hail.fill"
        case "thundery outbreaks possible", "patchy light rain with thunder", "moderate or heavy rain with thunder", "patchy light snow with thunder", "moderate or heavy snow with thunder":
            return "cloud.bolt.rain.fill"
        case "blowing snow", "blizzard":
            return "cloud.snow.blizzard.fill"
        case "freezing fog":
            return "cloud.fog.fill"
        case "torrential rain shower", "moderate or heavy rain shower":
            return "cloud.rain.fill"
        case "light snow showers", "moderate or heavy snow showers":
            return "cloud.snow.fill"
        case "light showers of ice pellets", "moderate or heavy showers of ice pellets":
            return "cloud.hail.fill"
        default:
            return "questionmark.circle"
    }
}
