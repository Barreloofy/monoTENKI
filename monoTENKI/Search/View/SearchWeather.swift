//
//  SearchWeather.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/31/25 at 9:55 PM.
//

import SwiftUI

struct SearchWeather: View {
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    ZStack {
      Text("Search")
      AlignedHStack(alignment: .trailing) {
        Button(
          action: { dismiss() },
          label: {
            XIcon()
              .stroke(lineWidth: 3)
              .frame(width: 20, height: 20)
          })
      }
    }
    .font(.title)
    .fontWeight(.bold)
    .padding()
    Search(onlySearch: false)
  }
}
