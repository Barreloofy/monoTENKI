//
//  SearchView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 5:28 PM.
//

import SwiftUI
import os

struct SearchView: View {
  @EnvironmentObject private var weatherData: WeatherData
  @Environment(\.dismiss) private var dismiss
  @FocusState private var textFieldIsFocused: Bool
  @State private var locations = [Location]()
  @State private var locationHistory = [Location]()
  @State private var text = ""
  @State private var editing = false
  @State private var searchError = false
  @State private var noPermission = false
  private var locationManager = LocationManager.shared

  var body: some View {
    VStack {
      navigationBlock

      searchBlock

      resultBlock

      Spacer()
    }
    .font(.system(.title, design: .serif, weight: .bold))
    .foregroundStyle(.white)
    .padding()
    .background(.black)
    .onAppear { retrieve() }
    .onChange(of: locationHistory) { store() }
    .onChange(of: text) {
      if noPermission {
        noPermission = false
      } else {
        fetchLocations()
      }
    }
  }


  @ViewBuilder private var navigationBlock: some View {
    ZStack {
      AlignedHStack(alignment: .leading) {
        Button("Edit") {
          editing.toggle()
        }
      }

      Text("Location")

      AlignedHStack(alignment: .trailing) {
        Button("X") {
          dismiss()
        }
      }
    }
  }


  @ViewBuilder private var searchBlock: some View {

    SearchTextField(text: $text, focus: _textFieldIsFocused)
      .focused($textFieldIsFocused)

    AlignedHStack(alignment: .leading) {
      Button {
        setWeatherToCurrentLocation()
      } label: {
        Label("CURRENT LOCATION", systemImage: "location.fill")
      }
    }
    .font(.system(.title2, design: .serif, weight: .bold))
  }


  @ViewBuilder private var resultBlock: some View {
    if searchError || noPermission {
      resultError
    } else {
      resultList
    }
  }


  @ViewBuilder private var resultError: some View {
    if searchError {
      SearchErrorView(text: "UH OH, SOMETHING WENT WRONG") { fetchLocations() }
    } else {
      SearchErrorView(text: "monoTENKI DOSEN'T HAVE PERMISSION TO USE YOUR LOCATION")
    }
  }


  @ViewBuilder private var resultList: some View {
    if text.isEmpty {
      LocationHistoryView(locationHistory: $locationHistory, isEditing: $editing)
    } else {
      ScrollView {
        ForEach(locations) { location in
          SearchItem(location: location)
            .onTapGesture {
              weatherData.currentLocation = location.name
              locationManager.trackLocation = false
              dismiss()
              updateLocationHistory(with: location)
            }
        }
      }
    }
  }


  private func fetchLocations() {
    guard !text.isEmpty else { return }

    Task {
      do {
        locations = try await APIClient.fetch(service: .location, forType: [Location].self, query: text)
        searchError = false
      } catch {
        searchError = true
      }
    }
  }

  private func setWeatherToCurrentLocation() {
    guard locationManager.currentLocation != nil else {
      noPermission = true
      return
    }

    Task {
      do {
        try await weatherData.setWeatherToCurrentLocation()
        dismiss()
      } catch {
        searchError = true
      }
    }
  }
}


private extension SearchView {
  var fileManager: FileManager {
    FileManager.default
  }

  var locationHistoryFile: URL {
    let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    return documents.appending(path: "history")
  }

  func store() {
    do {
      let data = try JSONEncoder().encode(locationHistory)
      try data.write(to: locationHistoryFile)
    } catch {
      Logger.filesystem.error("\(error)")
    }
  }

  func retrieve() {
    do {
      guard fileManager.isReadableFile(atPath: locationHistoryFile.path()) else { return }

      let data = try Data(contentsOf: locationHistoryFile)
      locationHistory = try JSONDecoder().decode([Location].self, from: data)
    } catch {
      Logger.filesystem.error("\(error)")
    }
  }

  func updateLocationHistory(with key: Location) {
    for (index, location) in locationHistory.enumerated() {
      guard key == location else { continue }

      locationHistory.remove(at: index)
      locationHistory.insert(location, at: 0)

      store()

      return
    }

    locationHistory.insert(key, at: 0)

    store()
  }
}


#Preview {
  SearchView()
    .environmentObject(WeatherData())
}
