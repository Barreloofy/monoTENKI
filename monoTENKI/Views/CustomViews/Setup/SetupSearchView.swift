//
//  SetupSearchView.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/14/25 at 12:54 PM.
//

import SwiftUI

extension SetupView {
  struct SetUpSearchView: View {
    @EnvironmentObject private var weatherData: WeatherData
    @State private var locations: [Location] = []
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    @Binding var selection: Int

    var body: some View {
      VStack {
        Text("Location")

        SearchTextField(text: $text, focus: _isFocused)
          .focused($isFocused)

        ScrollView {
          ForEach(locations) { location in
            SearchItem(location: location)
              .onTapGesture {
                weatherData.currentLocation = location.name
                selection += 1
              }
          }
        }
      }
      .font(.system(.title, design: .serif, weight: .bold))
      .foregroundStyle(.white)
      .padding()
      .background(.black.opacity(0.98))
      .onChange(of: text) { fetchLocations() }
    }

    private func fetchLocations() {
      Task {
        guard let locations = try? await APIClient.fetch(
          service: .location,
          forType: [Location].self,
          query: text
        ) else { return }
        
        self.locations = locations
      }
    }
  }
}
