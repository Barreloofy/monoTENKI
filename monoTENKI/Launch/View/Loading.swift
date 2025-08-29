//
// Loading.swift
// monoTENKI
//
// Created by Barreloofy on 6/27/25 at 1:40 PM
//

import SwiftUI

struct Loading: View {
  @State private var currentPhase = ""

  private let phaseSequence = ["Loading", "Loading.", "Loading..", "Loading..."]

  var body: some View {
    Text(currentPhase)
      .task {
        while !Task.isCancelled {
          for phase in phaseSequence {
            try? await Task.sleep(for: .seconds(0.5))
            currentPhase = phase
          }
        }
      }
  }
}
