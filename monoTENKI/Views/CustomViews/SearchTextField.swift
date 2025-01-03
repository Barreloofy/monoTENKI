//
//  SearchTextField.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/2/25 at 11:08 PM.
//

import SwiftUI

struct SearchTextField: ViewModifier {
    var text: String
    @FocusState var focus: Bool
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .tint(.white)
            .overlay(alignment: .leading) {
                if text.isEmpty {
                    Text("SEARCH...")
                        .foregroundStyle(.white)
                        .onTapGesture {
                            focus = true
                        }
                }
            }
    }
}
extension View {
    func searchTextField(_ text: String, _ focus: FocusState<Bool>) -> some View {
        self.modifier(SearchTextField(text: text, focus: focus))
    }
}
