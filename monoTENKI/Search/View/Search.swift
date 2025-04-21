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
  @Environment(LocationAggregate.self) private var locationAggregate
  @Environment(\.scenePhase) private var scenePhase
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
        .task(id: scenePhase) {
          guard scenePhase == .active else { return }

          for await query in queryChannel.debounce(for: .seconds(0.333)) {
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
          LazyVStack(spacing: 0) {
            ForEach(searchModel.getContent(text.isEmpty)) { result in
              SwipeableRow(
                allowSwipe: text.isEmpty,
                action: { searchModel.removeHistory(location: result) },
                content: {
                  AlignedHStack(alignment: .leading) {
                    Text(result.completeName)
                      .onTapGesture {
                        locationAggregate.trackLocation = false
                        locationAggregate.location = result.coordinate
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
        Text("It seems an error occured, please check your internet connection")
          .searchErrorStyle()
      case .location:
        Text("It seems an error occured, please check if location service is enbaled and permission was granted")
          .searchErrorStyle()
      }

      Spacer()
    }
    .font(.title3)
    .lineLimit(1)
  }


  @ViewBuilder private var locationButton: some View {
    if !onlySearch {
      AlignedHStack(alignment: .leading) {
        Button(
          action: {
            Task {
              if await CLServiceSession.getAuthorization() {
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

// MARK: - Error enum for Search view. Used to conditionally handle UI error presentation
extension Search {
  enum Errors {
    case none
    case search
    case location
  }
}
