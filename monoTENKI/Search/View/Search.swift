//
// Search.swift
// monoTENKI
//
// Created by Barreloofy on 3/25/25 at 12:09 PM.
//

import SwiftUI

struct Search: View {
  enum SearchState {
    case presenting, queryFailed, permissionDenied
  }

  @State private var state = SearchState.presenting
  @State private var query = ""
  @State private var result = Locations()

  var body: some View {
    NavigationStack {
      VStack(spacing: 10) {
        SearchBox(
          query: $query,
          state: $state,
          result: $result)

        TrackLocationBox(state: $state)

        switch state {
        case .presenting:
          ResultBox(
            result: result,
            searchIsEmpty: query.isEmpty)

        case .queryFailed:
          Text("""
          Search couldn't be completed, 
          check connection status
          """)
          .configureMessage()

        case .permissionDenied:
          Group {
            Text("""
            No permission to access location, 
            grand permission to receive the most accurate weather
            """)

            Link(
              "Open Settings",
              destination: URL(
                string: UIApplication.openSettingsURLString)!)
            .buttonStyle(.bordered)
          }
          .configureMessage()
        }

        Spacer()
      }
      .configureNavigationBar()
      .subtitleFont()
      .fontWeight(.medium)
      .padding()
      .animating(state, with: .smooth)
    }
  }
}


#Preview {
  Search()
    .configureApp()
    .environment(LocationAggregate())
}
