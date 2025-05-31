//
//  Search.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/25/25 at 12:09 PM.
//

import SwiftUI
import CoreLocation

struct Search: View {
  enum SearchState {
    case presenting, searchError, locationError
  }

  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.dismiss) private var dismiss
  @Environment(\.apiSource) private var apiSource
  @Environment(LocationAggregate.self) private var locationAggregate

  @State private var state = SearchState.presenting
  @State private var text = ""
  @State private var results = Locations()
  @State private var history = History()

  let setup: Bool

  private var presentedLocations: Locations {
    text.isEmpty ? history.locations : results
  }

  var body: some View {
    VStack(spacing: 10) {
       Row(
         leading: {},
         center: { Text("Search") },
         trailing: {
           Button(
             action: { dismiss() },
             label: { XIcon().iconStyleX })
         })
       .font(.title)
       .enabled(!setup)

      TextField(
        "",
        text: $text,
        prompt: Text("Search").foregroundStyle(colorScheme.foreground))
      .textInputAutocapitalization(.characters)
      .debounce(id: text) {
        do {
          switch apiSource {
          case .weatherApi:
            results = try await Array(WeatherAPI.search(query: text).fetchSearch().prefix(10))
          case .accuWeather:
            results = try await Array(AccuWeather.search(query: text).fetchSearch().prefix(10))
          }
          state = .presenting
        } catch {
          state = .searchError
        }
      }

      AlignedHStack(alignment: .leading) {
        Button(
          action: {
            Task {
              if await CLServiceSession.getAuthorizationStatus() {
                locationAggregate.trackLocation = true
                dismiss()
              } else {
                state = .locationError
              }
            }
          },
          label: { Label("CURRENT LOCATION", systemImage: "location.fill") })
      }
      .fontWeight(.medium)
      .enabled(!setup)

      switch state {
      case .presenting:
        ScrollView {
          LazyVStack(spacing: 0) {
            ForEach(presentedLocations) { result in
              AlignedHStack(alignment: .leading) {
                Text(result.completeName)
                  .onTapGesture {
                    locationAggregate.trackLocation = false
                    locationAggregate.location = result.coordinate.stringRepresentation
                    history.add(result)
                    dismiss()
                  }
              }
              .swipeToDelete(isEnabled: text.isEmpty) { history.remove(result) }
            }
          }
          .lineLimit(1)
        }
        .scrollIndicators(.never)

      case .searchError:
        Text("Search couldn't be completed, check connection status")
          .font(.footnote)

      case .locationError:
        Text("No permission to access location, grand permission to receive the most accurate weather")
          .font(.footnote)
        Link("Open Settings App", destination: URL(string: UIApplication.openSettingsURLString)!)
          .buttonStyle(.bordered)
      }

      Spacer()
    }
    .font(.title3)
    .padding()
    .animation(reduceMotion ? nil : .default.speed(0.5), value: state)
    .onAppear { history.load() }
  }
}
