//
// Loading.swift
// monoTENKI
//
// Created by Barreloofy on 6/27/25 at 1:40 PM
//

import SwiftUI

struct Loading: View {
  @State private var text = ""

  private let phaseSequence = ["Loading", "Loading.", "Loading..", "Loading..."]

  var body: some View {
    Text(text)
      .task {
        while !Task.isCancelled {
          for phase in phaseSequence {
            try? await Task.sleep(for: .seconds(0.5))
            text = phase
          }
        }
      }
  }
}


#Preview {
  Loading()
}
