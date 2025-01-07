//
//  SearchView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 5:28 PM.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var weatherData: WeatherData
    @FocusState private var textFieldIsFocused: Bool
    @State private var results = [Location]()
    @State private var text = ""
    private var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            ZStack {
                Text("Location")
                HStack {
                    Spacer()
                    Text("X")
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            TextField("", text: $text)
                .searchTextField(text, _textFieldIsFocused)
                .focused($textFieldIsFocused)
                .font(.system(.title, design: .rounded, weight: .bold))
            HStack {
                Button {
                    fetchCurrentLocation()
                } label: {
                    Label("CURRENT LOCATION", systemImage: "location.fill")
                }
                Spacer()
            }
            .font(.system(.title3, design: .serif, weight: .bold))
            ScrollView {
                ForEach(results) { result in
                    HStack {
                        Text(result.name)
                            .layoutPriority(1)
                        Text(result.country)
                        Spacer()
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .truncationMode(.tail)
                    .onTapGesture {
                        weatherData.currentLocation = result.name
                        dismiss()
                    }
                }
            }
        }
        .font(.system(.title, design: .serif, weight: .bold))
        .foregroundStyle(.white)
        .padding()
        .background(.black)
        .onChange(of: text) {
            fetchLocations(text)
        }
    }
    
    private func fetchLocations(_ query: String) {
        Task {
            do {
                results = try await APIClient.fetch(service: .location, forType: [Location].self, query)
            } catch {
                print(error)
            }
        }
    }
    
    private func fetchCurrentLocation() {
        Task {
            do {
                guard let query = locationManager.stringLocation else { return }
                print(query)
                let results = try await APIClient.fetch(service: .location, forType: [Location].self, query)
                guard let firstResult = results.first else { return }
                weatherData.currentLocation = firstResult.name
                dismiss()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(WeatherData())
}
