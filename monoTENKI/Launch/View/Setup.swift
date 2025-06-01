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

  @AppStorage("presentSearch") private var presentSearch = false

  @Binding var setupCompleted: Bool

  var body: some View {
    VStack {
      Group {
        Image(systemName: "location.fill")
          .styled(size: 100)
          .offset(y: -25)

        Text("Accurate weather")
          .font(.title)

        Text("Location is used to provide the most accurate weather")
          .font(.footnote)
      }
      .multilineTextAlignment(.center)
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
      }
      .buttonStyle(.permission)
      .fixedSize()
      .offset(y: 150)
    }
    .sheet(isPresented: $presentSearch) {
      Search(setup: true)
        .interactiveDismissDisabled()
        .presentationBackground(colorScheme.background)
    }
    .onChange(of: locationAggregate.location) { setupCompleted = true }
    .tint(colorScheme.foreground)
  }
}
