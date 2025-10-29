//
//  Recovery.swift
//  monoTENKI
//
//  Created by Barreloofy on 5/8/25.
//

import SwiftUI

struct Recovery: View {
  @Environment(\.apiSourceInUse) private var apiSourceInUse

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

      List(APISource.allCases) { source in
        Button {
          UserDefaults.standard.setRawRepresentable(
            \.apiSourceInUse,
             value: source)
        } label: {
          Label(
            source.rawValue,
            systemImage: apiSourceInUse == source ? "checkmark" : "")
          .labelStyle(.trailing)
        }
        .listRowBackground(Color.clear)
        .sensoryFeedback(.impact, trigger: apiSourceInUse)
      }
      .listStyle(.plain)
      .scrollDisabled(true)
      .containerRelativeFrame([.vertical, .horizontal], count: 2, spacing: 0)
    }
    .offset(y: 75)
  }
}


#Preview {
  Recovery() {}
    .configureApp()
}
