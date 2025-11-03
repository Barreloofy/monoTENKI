//
// ResultBox.swift
// monoTENKI
//
// Created by Barreloofy on 11/1/25 at 1:38 PM
//

import SwiftUI
import SwiftData

struct ResultBox: View {
  @Query(
    Location.descriptor,
    animation: .smooth(duration: 1))
  private var history: Locations

  @Environment(LocationAggregate.self) private var locationAggregate
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  let result: Locations
  let searchIsEmpty: Bool

  private var locations: Locations {
    searchIsEmpty ? history : result
  }

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(locations) { location in
          Button {
            location.accessDate = .now
            modelContext.insert(location)
            locationAggregate.stopTracking()
            locationAggregate.setLocation(location.coordinate)
            dismiss()
          } label: {
            AlignedHStack(alignment: .leading) {
              Label(
                location.completeName,
                systemImage: "mappin.and.ellipse")
            }
          }
          .buttonStyle(
            SwipeableButtonStyle(
              enabled: searchIsEmpty,
              accessibilityMessage: "\(location.completeName) deleted",
              resetOffset: false) { modelContext.delete(location) })
        }
      }
    }
    .scrollIndicators(.never)
  }
}
