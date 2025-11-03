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

  @AppStorage(\.presentSearch) private var presentSearch

  @Binding var completed: Bool

  var body: some View {
    VStack {
      Group {
        Image(systemName: "location.fill")
          .headlineFont()
          .offset(y: -25)

        Text("Accurate weather")

        Text("Location is used to provide the most accurate weather")
          .configureMessage()
      }
      .offset(y: -25)

      VStack {
        Button("Grand access") {
          Task {
            if try await CLLocationUpdate.getAuthorization() {
              locationAggregate.startTracking()
            } else {
              presentSearch = true
            }
          }
        }

        Button("Deny access") { presentSearch = true }
          .sheet(isPresented: $presentSearch) {
            Search()
              .configureSheet()
              .interactiveDismissDisabled()
          }
      }
      .buttonStyle(.permission)
      .fixedSize()
    }
    .onChange(of: locationAggregate.location) { completed = true }
  }
}


#Preview {
  Setup(completed: .constant(false))
    .environment(LocationAggregate())
    .configureApp()
}
