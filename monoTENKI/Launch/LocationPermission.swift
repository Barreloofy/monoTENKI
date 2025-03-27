//
//  LocationPermission.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/23/25 at 10:18 PM.
//

import SwiftUI
import CoreLocation

struct LocationPermission: View {
  @Binding var permissionGranted: Bool?

  var body: some View {
    VStack(spacing: 10) {
      Group {
        Image(systemName: "location.fill")
          .resizable()
          .scaledToFit()
          .frame(width: 100)
          .offset(y: -25)

        Text("accurate weather")
          .font(.title)
          .fontWeight(.bold)

        Text("location is used to show you the most accurate weather!")
          .font(.footnote)
          .fontDesign(.monospaced)
          .multilineTextAlignment(.center)
      }
      .offset(y: -10)

      Button("Grand access") {
        Task {
          let session = CLServiceSession(authorization: .whenInUse)

          for try await diagnostic in session.diagnostics {
            guard !diagnostic.authorizationRequestInProgress else { continue }

            switch diagnostic.authorizationDenied {
            case true:
              permissionGranted = false
            case false:
              permissionGranted = true
            }
            break
          }
        }
      }
      .buttonStyle(.permission)
      .offset(y: 150)
    }
    .fontWeight(.medium)
    .textCase(.uppercase)
    .padding(.horizontal, 25)
  }
}
