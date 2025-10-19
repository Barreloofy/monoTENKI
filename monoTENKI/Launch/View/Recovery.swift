//
//  Recovery.swift
//  monoTENKI
//
//  Created by Barreloofy on 5/8/25.
//

import SwiftUI

struct Recovery: View {
  @Environment(\.apiSource) private var apiSource

  @State private var task: Task<Void, Never>?

  let action: () async -> Void

  var body: some View {
    VStack {
      Text("""
      Error, check connection status, 
      if the error persists please try again later
      """)
      .configureMessage()

      Button("Try again") {
        task?.cancel()
        task = Task { await action() }
      }
      .buttonStyle(.permission)
      .fixedSize()
      .padding(.vertical)

      Text("Try diffrent Source")
        .padding(.bottom)

      List(APISource.allCases) { source in
        Button(
          action: { setEnvironment(.apiSourceInUse, value: source) },
          label: {
            Label(
              source.rawValue,
              systemImage: apiSource == source ? "checkmark" : "")
            .labelStyle(.trailing)
          })
        .listRowBackground(Color.clear)
        .sensoryFeedback(.impact, trigger: apiSource)
      }
      .listStyle(.plain)
      .scrollDisabled(true)
      .containerRelativeFrame([.vertical, .horizontal]) { length, axis in
        if axis == .vertical {
          length * 0.2
        } else {
          length * 0.5
        }
      }
    }
    .offset(y: -75)
    .padding(.horizontal)
  }
}


#Preview {
  Recovery() {}
    .configureApp()
}
