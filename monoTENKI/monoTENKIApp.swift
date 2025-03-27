//
//  monoTENKIApp.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/16/25 at 8:31 PM.
//

import SwiftUI

@main
struct monoTENKIApp: App {
  @AppStorage("setupCompleted") private var setupCompleted = false
  @AppStorage("measurementSystem") private var useMetric = false
  @State private var locationModel = LocationModel()

  var body: some Scene {
    WindowGroup {
      if setupCompleted {
        Search { _ in }
          .foregroundStyle(.white)
          .background(.black)
      } else {
        Setup(setupCompleted: $setupCompleted)
          .foregroundStyle(.white)
          .background(.black)
      }
    }
    .environment(locationModel)
    .environment(\.measurementSystem, useMetric ? .metric : .Imperial)
  }
}
