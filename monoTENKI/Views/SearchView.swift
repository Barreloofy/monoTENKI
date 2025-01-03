//
//  SearchView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 5:28 PM.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var textFieldIsFocused: Bool
    @State private var text = ""
    
    var body: some View {
        VStack {
            ZStack {
                Text("Location")
                HStack {
                    Spacer()
                    Text("X")
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            TextField("", text: $text)
                .searchTextField(text, _textFieldIsFocused)
                .focused($textFieldIsFocused)
                .font(.system(.title, design: .rounded, weight: .bold))
            ScrollView {
                ForEach(0..<10) { _ in
                    HStack {
                        Text("Hello, World!")
                        Spacer()
                    }
                }
            }
        }
        .font(.system(.title, design: .serif, weight: .bold))
        .foregroundStyle(.white)
        .padding()
        .background(.black)
    }
}

#Preview {
    SearchView()
}
