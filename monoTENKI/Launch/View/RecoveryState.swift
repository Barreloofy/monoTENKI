//
//  RecoveryState.swift
//  monoTENKI
//
//  Created by Barreloofy on 5/8/25.
//

import SwiftUI

struct RecoveryState: View {
  @Binding var source: APISource

  let action: () async -> Void

  var body: some View {
    VStack {
      Text("Error, check connection status, if the error persists please try again later")

      Button("Try again") {
        Task { await action() }
      }
      .padding(.vertical)
      .buttonStyle(.permission)

      Text("Try diffrent Source")

      HStack {
        ForEach(APISource.allCases, id: \.self) {
          Text($0.rawValue)
            .selectedStyle(target: $0, value: $source)
        }
      }
      .font(.subheadline)
    }
    .font(.footnote)
    .multilineTextAlignment(.center)
    .offset(y: -75)
  }
}
