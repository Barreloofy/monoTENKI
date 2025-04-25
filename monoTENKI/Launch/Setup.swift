//
//  Setup.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/24/25 at 12:24 PM.
//

import SwiftUI
import CoreLocation

struct Setup: View {
  @Environment(LocationAggregate.self) private var locationAggregate
  @Environment(\.colorScheme) private var colorScheme

  @AppStorage("showSearch") private var showSearch = false

  @Binding var setupCompleted: Bool

  var body: some View {
    VStack(spacing: 10) {
      Group {
        Image(systemName: "location.fill")
          .styled(size: 100)
          .offset(y: -25)

        Text("accurate weather")
          .font(.title)
          .fontWeight(.bold)

        Text("location is used to provide the most accurate weather")
          .font(.footnote)
      }
      .multilineTextAlignment(.center)
      .offset(y: -10)

      Group {
        Button("Grand access") {
          Task {
            let serviceStream = CLServiceSession(authorization: .whenInUse)

            for try await diagnostic in serviceStream.diagnostics where !diagnostic.authorizationRequestInProgress {
              if diagnostic.authorizationDenied {
                showSearch = true
              } else {
                locationAggregate.trackLocation = true
              }
              break
            }
          }
        }
        Button("Deny access ") { showSearch = true }
      }
      .buttonStyle(.permission)
      .offset(y: 150)
    }
    .sheet(isPresented: $showSearch) {
      Search(setup: true)
        .presentationBackground(colorScheme.background)
        .interactiveDismissDisabled()
    }
    .onChange(of: locationAggregate.location) { setupCompleted = true }
  }
}
