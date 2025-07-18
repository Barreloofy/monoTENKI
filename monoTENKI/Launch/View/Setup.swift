//
//  Setup.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/24/25 at 12:24 PM.
//

import SwiftUI
import CoreLocation

struct Setup: View {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(LocationAggregate.self) private var locationAggregate

  @AppStorage(StorageKeys.presentSearch.rawValue) private var presentSearch = false

  @Binding var setupCompleted: Bool

  var body: some View {
    VStack {
      Group {
        Image(systemName: "location.fill")
          .styled(size: 100)
          .offset(y: -25)

        Text("Accurate weather")

        Text("Location is used to provide the most accurate weather")
          .font(.footnote)
          .fontWeight(.medium)
      }
      .offset(y: -25)

      VStack {
        Button("Grand access") {
          Task {
            if await CLServiceSession.getAuthorizationStatus() {
              locationAggregate.trackLocation = true
            } else {
              presentSearch = true
            }
          }
        }

        Button("Deny access") { presentSearch = true }
          .sheet(isPresented: $presentSearch) {
            Search(setup: true)
              .interactiveDismissDisabled()
              .sheetConfiguration()
          }
      }
      .buttonStyle(.permission)
      .fixedSize()
      .offset(y: 150)
    }
    .lineLimit(nil)
    .tint(colorScheme.foreground)
    .onChange(of: locationAggregate.location) { setupCompleted = true }
  }
}
