//
//  Search.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/25/25 at 12:09 PM.
//

import SwiftUI

struct Search: View {
  @Environment(LocationModel.self) private var locationModel

  @State private var searchModel = SearchModel()
  @State private var text = ""
  @State private var error = Errors.none

  @FocusState private var searchIsFocus: Bool

  let action: (Location) -> Void

  var body: some View {
    VStack {
      SearchTextField(text: $text)

      AlignedHStack(alignment: .leading) {
        Button(
          action: { locationModel.trackLocation = true },
          label: { Label("CURRENT LOCATION", systemImage: "location.fill") }
        )
      }

      switch error {
      case .none:
        ScrollView {
          ForEach(searchModel.results) { result in
            AlignedHStack(alignment: .leading) {
              Text(result.completeName)
                .onTapGesture { action(result) }
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
    .textCase(.uppercase)
    .font(.system(.title3, design: .monospaced, weight: .medium))
    .lineLimit(1)
    .padding()
    .onChange(of: text) {
      guard !text.isEmpty else { return }

      Task {
        do {
          try await searchModel.getLocations(matching: text)
          error = .none
        } catch {
          print(error)
          self.error = .search
        }
      }
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
