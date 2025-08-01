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
  @Environment(\.dismiss) private var dismiss
  @Environment(\.apiSource) private var apiSource
  @Environment(LocationAggregate.self) private var locationAggregate
  @ColorSchemeWrapper private var colorSchemeWrapper

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
        center: { Text("Search") },
        trailing: {
          Button(
            action: { dismiss() },
            label: {
              Image(systemName: "xmark")
                .fontWeight(.regular)
            })
        })
      .topBarConfiguration()
      .enabled(!setup)

      TextField(
        "",
        text: $text,
        prompt: Text("Search").foregroundStyle(colorSchemeWrapper))
      .textInputAutocapitalization(.characters)
      .multilineTextAlignment(.leading)
      .debounce(id: text) {
        do {
          state = .presenting

          switch apiSource {
          case .weatherAPI:
            results = try await Array(WeatherAPI.fetchSearch(for: text).prefix(10))
          case .accuWeather:
            results = try await Array(AccuWeather.fetchSearch(for: text).prefix(10))
          }
        } catch {
          guard (error as? URLError)?.code != .cancelled else { return }

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
      .enabled(!setup)

      switch state {
      case .presenting:
        ScrollView {
          LazyVStack(spacing: 0) {
            ForEach(presentedLocations) { result in
              AlignedHStack(alignment: .leading) {
                Label(result.completeName, systemImage: "mappin.and.ellipse")
                  .onTapGesture {
                    locationAggregate.trackLocation = false
                    locationAggregate.location = result.coordinate.stringRepresentation
                    history.add(result)
                    dismiss()
                  }
                  .accessibilityAddTraits(.isSelected)
              }
              .swipeToDelete(isEnabled: text.isEmpty) { history.remove(result) }
            }
          }
        }
        .scrollIndicators(.never)

      case .searchError:
        Text("Search couldn't be completed, check connection status")
          .errorTextConfiguration()

      case .locationError:
        Group {
          Text("No permission to access location, grand permission to receive the most accurate weather")

          Link("Open Settings App", destination: URL(string: UIApplication.openSettingsURLString)!)
            .buttonStyle(.bordered)
        }
        .errorTextConfiguration()
      }

      Spacer()
    }
    .overviewFont()
    .fontWeight(.medium)
    .padding()
    .animation(reduceMotion ? nil : .default.speed(0.5), value: state)
    .onAppear { history.load() }
  }
}
