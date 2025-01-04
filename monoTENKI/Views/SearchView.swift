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
    @State private var results = [Location]()
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
                ForEach(results) { result in
                    HStack {
                        Text(result.name)
                            .layoutPriority(1)
                        Text(result.country)
                        Spacer()
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .truncationMode(.tail)
                }
            }
        }
        .font(.system(.title, design: .serif, weight: .bold))
        .foregroundStyle(.white)
        .padding()
        .background(.black)
        .onChange(of: text) {
            fetchLocations(text)
        }
    }
    
    private func fetchLocations(_ query: String) {
        Task {
            results = try await APIClient.fetch(service: .location, forType: [Location].self, query)
        }
    }
}

#Preview {
    SearchView()
}
