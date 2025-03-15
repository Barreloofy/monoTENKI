//
//  SearchTextField.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/2/25 at 11:08 PM.
//

import SwiftUI

struct SearchTextField: View {
  @Binding var text: String
  @FocusState var focus: Bool

  var body: some View {
    TextField("", text: $text)
      .foregroundStyle(.white)
      .tint(.white)
      .font(.system(.title, design: .rounded, weight: .bold))
      .textInputAutocapitalization(.words)
      .autocorrectionDisabled()
      .overlay(alignment: .leading) {
        if text.isEmpty {
          Text("SEARCH...")
            .foregroundStyle(.white)
            .font(.system(.title, design: .rounded, weight: .bold))
            .onTapGesture { focus = true }
        }
      }
  }
}
