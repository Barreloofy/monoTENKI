//
//  LocationAccessError.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/24/25.
//

import SwiftUI

struct LocationAccessError: View {

  var body: some View {
    VStack {
      Text("No permission to access location, grand permission to receive the most accurate weather")
        .font(.footnote)
      Link("Open Settings App", destination: URL(string: UIApplication.openSettingsURLString)!)
        .buttonStyle(.bordered)
        .fontWeight(.bold)
        .font(.body)
    }
  }
}
