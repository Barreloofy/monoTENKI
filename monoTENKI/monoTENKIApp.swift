//
//  monoTENKIApp.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/16/25 at 8:31 PM.
//

import SwiftUI

@main
struct monoTENKIApp: App {
  @AppStorage("measurementSystem") private var useMetric = false

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.measurementSystem, useMetric ? .metric : .Imperial)
    }
  }
}
