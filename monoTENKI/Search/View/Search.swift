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
    case none
    case search
    case location
  }

  @Environment(LocationAggregate.self) private var locationAggregate
  @Environment(\.dismiss) private var dismiss

  @State private var searchModel = SearchModel()
  @State private var text = ""
  @State private var error: Error = .none

  let setup: Bool

  private var errorMessage: String {
    switch error {
    case .none:
      ""
    case .search:
      "It seems an error occured, please check the connection status"
    case .location:
      "It seems an error occured, please check if location service is enabled and permission was granted"
    }
  }

  var body: some View {
    VStack {
      header

      SearchTextField(text: $text)
        .debounce(id: text, duration: .seconds(0.5)) {
          do {
            try await searchModel.getLocations(matching: text)
            error = .none
          } catch {
            self.error = .search
          }
        }

      locationButton

      switch error {
      case .none:
        ScrollView {
          LazyVStack(spacing: 0) {
            ForEach(searchModel.getContent(condition: text.isEmpty)) { result in
              SwipeableRow(
                allowSwipe: text.isEmpty,
                action: { searchModel.removeHistory(location: result) },
                content: {
                  AlignedHStack(alignment: .leading) {
                    Text(result.completeName)
                      .lineLimit(1)
                      .onTapGesture {
                        locationAggregate.trackLocation = false
                        locationAggregate.location = result.coordinate.stringRepresentation
                        searchModel.updateHistory(with: result)
                        dismiss()
                      }
                  }
                })
            }
          }
        }
        .scrollIndicators(.never)
      case .search:
        Text(errorMessage)
          .font(.footnote)
      case .location:
        LocationAccessError(message: errorMessage)
      }

      Spacer()
    }
    .font(.title3)
    .padding()
  }


  @ViewBuilder private var header: some View {
    if !setup {
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
    }
  }


  @ViewBuilder private var locationButton: some View {
    if !setup {
      AlignedHStack(alignment: .leading) {
        Button(
          action: {
            Task {
              if await CLServiceSession.getAuthorizationStatus() {
                locationAggregate.trackLocation = true
                dismiss()
              } else {
                error = .location
              }
            }
          },
          label: { Label("CURRENT LOCATION", systemImage: "location.fill") })
      }
      .fontWeight(.regular)
    }
  }
}
