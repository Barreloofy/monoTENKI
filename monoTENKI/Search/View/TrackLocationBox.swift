//
// TrackLocationBox.swift
// monoTENKI
//
// Created by Barreloofy on 11/1/25 at 2:44 PM
//

import SwiftUI
import CoreLocation

struct TrackLocationBox: View {
  @Environment(LocationAggregate.self) private var locationAggregate
  @Environment(\.setupCompleted) private var setupCompleted
  @Environment(\.dismiss) private var dismiss

  @Binding var state: Search.SearchState

  var body: some View {
    AlignedHStack(alignment: .leading) {
      Button {
        Task {
          if try await CLLocationUpdate.getAuthorization() {
            locationAggregate.startTracking()
            dismiss()
          } else {
            state = .permissionDenied
          }
        }
      } label: {
        Label("CURRENT LOCATION", systemImage: "location.fill")
      }
    }
    .visible(setupCompleted)
  }
}
