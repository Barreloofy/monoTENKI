//
//  SearchErrorView.swift
//  monoTENKI
//
//  Created by Barreloofy on 2/12/25 at 2:16 PM.
//

import SwiftUI

extension SearchView {
  struct SearchErrorView: View {
    private let text: String
    private let action: (() -> Void)?

    init(text: String, action: (() -> Void)? = nil) {
      self.text = text
      self.action = action
    }

    var body: some View {
      Text(text)
        .font(.system(.title3, design: .serif, weight: .bold))
        .lineLimit(2)
        .minimumScaleFactor(0.8)
        .multilineTextAlignment(.center)
        .padding(.top, 25)

      if let action = action {
        Button("TAP TO RETRY") { action() }
          .buttonStyle(.monoBordered)
          .font(.system(.headline, design: .serif, weight: .bold))
      }
    }
  }
}
