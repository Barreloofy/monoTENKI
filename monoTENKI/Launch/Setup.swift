//
//  Setup.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/24/25 at 12:24 PM.
//

import SwiftUI

struct Setup: View {
  @Environment(LocationModel.self) private var locationModel
  @Environment(\.colorScheme) private var colorScheme

  @AppStorage("showSearch") private var showSearch = false
  @State private var permissionGranted: Bool?

  @Binding var setupCompleted: Bool

  var body: some View {
    LocationPermission(permissionGranted: $permissionGranted)
      .sheet(isPresented: $showSearch) {
        Search(onlySearch: true)
        .presentationBackground(colorScheme == .light ? .white : .black)
        .interactiveDismissDisabled()
      }
      .onChange(of: locationModel.location) { setupCompleted = true }
      .onChange(of: permissionGranted) {
        switch permissionGranted {
        case true?:
          setupCompleted = true
          locationModel.trackLocation = true
        case false?:
          showSearch = true
        case .none:
          break
        }
      }
  }
}
