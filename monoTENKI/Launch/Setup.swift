//
//  Setup.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/24/25 at 12:24 PM.
//

import SwiftUI

struct Setup: View {
  @Environment(LocationAggregate.self) private var locationAggregate
  @Environment(\.colorScheme) private var colorScheme

  @AppStorage("showSearch") private var showSearch = false
  @State private var permissionGranted: Bool?

  @Binding var setupCompleted: Bool

  var body: some View {
    LocationPermission(permissionGranted: $permissionGranted)
      .sheet(isPresented: $showSearch) {
        Search(onlySearch: true)
          .padding()
          .presentationBackground(colorScheme.background)
          .interactiveDismissDisabled()
      }
      .onChange(of: locationAggregate.location) { setupCompleted = true }
      .onChange(of: permissionGranted) {
        switch permissionGranted {
        case true?:
          setupCompleted = true
          locationAggregate.trackLocation = true
        case false?:
          showSearch = true
        case .none:
          break
        }
      }
  }
}
