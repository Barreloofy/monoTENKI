//
//  Search.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/25/25 at 12:09 PM.
//

import SwiftUI
import CoreLocation

struct Search: View {
  enum Error {
    case none, search, location
  }

  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.dismiss) private var dismiss
  @Environment(\.apiSource) private var apiSource
  @Environment(LocationAggregate.self) private var locationAggregate

  @State private var error = Error.none
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
      .fontWeight(.bold)
      .enabled(!setup)

      TextField(
        "",
        text: $text,
        prompt: Text("Search").foregroundStyle(colorScheme.foreground))
        .textInputAutocapitalization(.characters)
        .debounce(id: text) {
          guard !text.isEmpty else { return }
          do {
            switch apiSource {
            case .weatherApi:
              results = try await WeatherAPI.search(query: text).fetchSearch()
            case .accuWeather:
              results = try await AccuWeather.search(query: text).fetchSearch()
            }
            error = .none
          } catch {
            self.error = .search
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
                 self.error = .location
               }
             }
          },
          label: { Label("CURRENT LOCATION", systemImage: "location.fill") })
      }
      .fontWeight(.regular)
      .enabled(!setup)

      switch error {
      case .none:
        ScrollView {
          LazyVStack(spacing: 0) {
            ForEach(presentedLocations) { result in
              AlignedHStack(alignment: .leading) {
                Text(result.completeName)
                  .onTapGesture {
                    locationAggregate.trackLocation = false
                    locationAggregate.location = result.coordinate.stringRepresentation
                    dismiss()
                    history.add(result)
                  }
              }
              .swipeToDelete(isEnabled: text.isEmpty) { history.remove(result) }
            }
          }
          .lineLimit(1)
        }
      case .search:
        Text("Search couldn't be completed, check connection status")
      case .location:
        LocationAccessError()
      }

      Spacer()
    }
    .font(.title3)
    .padding()
    .onAppear { history.load() }
  }
}
