//
//  Recovery.swift
//  monoTENKI
//
//  Created by Barreloofy on 5/8/25.
//

import SwiftUI

struct Recovery: View {
  @AppStorage(StorageKeys.apiSourceInUse.rawValue) private var apiSourceInUse = APISource.weatherAPI
  @State private var task: Task<Void, Never>?

  let action: () async -> Void

  var body: some View {
    VStack {
      Text("Error, check connection status, if the error persists please try again later")

      Button("Try again") {
        task?.cancel()
        task = Task { await action() }
      }
      .padding(.vertical)
      .fixedSize()
      .buttonStyle(.permission)

      Text("Try diffrent Source")

      HStack {
        ForEach(APISource.allCases, id: \.self) {
          Text($0.rawValue)
            .selectedStyle(target: $0, value: $apiSourceInUse)
        }
      }
      .font(.subheadline)
    }
    .font(.footnote)
    .offset(y: -75)
  }
}
