//
// SearchBox.swift
// monoTENKI
//
// Created by Barreloofy on 11/1/25 at 3:11 PM
//

import SwiftUI

struct SearchBox: View {
  @Environment(\.apiSourceInUse) private var apiSourceInUse
  @StyleMode private var styleMode

  @Binding var query: String
  @Binding var state: Search.SearchState
  @Binding var result: Locations

  var body: some View {
    Label {
      TextField(text: $query) {
        Text("Search")
          .foregroundStyle(styleMode)
      }
      .textInputAutocapitalization(.characters)
      .multilineTextAlignment(.leading)
      .debounce(id: query) {
        do {
          state = .presenting
          switch apiSourceInUse {
          case .weatherAPI:
            result = try await Array(WeatherAPI.fetchSearch(for: query).prefix(10))
          case .accuWeather:
            result = try await Array(AccuWeather.fetchSearch(for: query).prefix(10))
          }
        } catch URLError.cancelled {
          return
        } catch {
          state = .queryFailed
        }
      }
    } icon: {
      Image(systemName: "magnifyingglass")
    }
  }
}
