//
//  Search.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/25/25 at 12:09 PM.
//

import SwiftUI
import CoreLocation
import AsyncAlgorithms

struct Search: View {
  @Environment(LocationModel.self) private var locationModel
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.dismiss) private var dismiss

  @State private var searchModel = SearchModel()
  @State private var text = ""
  @State private var error = Errors.none

  @FocusState private var searchIsFocus: Bool

  private let queryChannel = AsyncChannel<String>()
  let onlySearch: Bool

  var body: some View {
    VStack {
      SearchTextField(text: $text)
        .task(id: text) {
          guard !text.isEmpty else { return }
          await queryChannel.send(text)
        }
        .task {
          for await query in queryChannel.debounce(for: .seconds(0.25)) {
            do {
              try await searchModel.getLocations(matching: query)
              error = .none
            } catch {
              self.error = .search
            }
          }
        }
      
      locationButton

      switch error {
      case .none:
        ScrollView {
          ForEach(searchModel.results) { result in
            AlignedHStack(alignment: .leading) {
              Text(result.completeName)
                .onTapGesture {
                  locationModel.trackLocation = false
                  locationModel.location = result.coordinates
                  dismiss()
                }
            }
          }
        }
        .scrollIndicators(.never)
      case .search:
        Text("It seems an error occured, please check your internet connection")
          .searchError()
      case .location:
        Text("It seems an error occured, please check if location service is enbaled and monoTENKI has permission")
          .searchError()
      }

      Spacer()
    }
    .font(.system(.title3, design: .monospaced, weight: .medium))
    .lineLimit(1)
    .padding()
  }


  @ViewBuilder private var locationButton: some View {
    if !onlySearch {
      AlignedHStack(alignment: .leading) {
        Button(
          action: {
            Task {
              if await CLServiceSession.getAuthorization() {
                locationModel.trackLocation = true
                dismiss()
              } else {
                error = .location
              }
            }
          },
          label: { Label("CURRENT LOCATION", systemImage: "location.fill") })
      }
      .tint(colorScheme.tint())
    }
  }
}


extension Search {
  enum Errors {
    case none
    case search
    case location
  }
}
