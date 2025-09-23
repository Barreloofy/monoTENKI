//
//  Recovery.swift
//  monoTENKI
//
//  Created by Barreloofy on 5/8/25.
//

import SwiftUI

struct Recovery: View {
  @AppStorage(.key(.apiSourceInUse)) private var apiSourceInUse = APISource.weatherAPI
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
              systemImage: apiSourceInUse == source ? "checkmark" : "")
            .labelStyle(.trailing)
          })
        .listRowBackground(Color.clear)
      }
      .listStyle(.plain)
      .scrollDisabled(true)
      .containerRelativeFrame(.vertical, count: 10, span: 2, spacing: 0)
      .containerRelativeFrame(.horizontal, count: 10, span: 5, spacing: 0)
    }
    .offset(y: -75)
    .padding(.horizontal)
  }
}


#Preview {
  Recovery() {}
    .configureApp()
}
