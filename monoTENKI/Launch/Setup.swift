//
//  Setup.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/24/25 at 12:24 PM.
//

import SwiftUI

struct Setup: View {
  @Environment(LocationModel.self) private var locationModel

  @AppStorage("showSearch") private var showSearch = false
  @State private var permissionGranted: Bool?

  @Binding var setupCompleted: Bool

  var body: some View {
    ZStack {
      Color(.black)
      LocationPermission(permissionGranted: $permissionGranted)
        .sheet(isPresented: $showSearch) {
          Search { result in
            locationModel.location = result.coordinates
            setupCompleted = true
          }
          .presentationBackground(.black)
          .interactiveDismissDisabled()
        }
    }
    .padding(-1)
    .ignoresSafeArea()
    .onChange(of: permissionGranted) {
      switch permissionGranted {
      case true?:
        setupCompleted = true
      case false?:
        showSearch = true
      case .none:
        break
      }
    }
  }
}
