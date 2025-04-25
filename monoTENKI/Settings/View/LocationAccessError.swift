//
//  LocationAccessError.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/24/25.
//

import SwiftUI

struct LocationAccessError: View {
  let message: String

  var body: some View {
    VStack {
      Text(message)
        .font(.footnote)
      Link("Open Settings App", destination: URL(string: UIApplication.openSettingsURLString)!)
        .buttonStyle(.bordered)
        .fontWeight(.bold)
        .font(.body)
    }
  }
}
