//
//  SearchTextField.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/27/25 at 1:16 PM.
//

import SwiftUI

struct SearchTextField: View {
  @Binding var text: String
  @FocusState private var focus: Bool

  var body: some View {
    TextField("", text: $text)
      .textInputAutocapitalization(.characters)
      .focused($focus)
      .background(alignment: .leading) {
        if text.isEmpty {
          Text("SEARCH...")
            .onTapGesture { focus = true }
        }
      }
  }
}
