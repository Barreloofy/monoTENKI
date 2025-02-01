//
//  LocationHistoryView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/31/25 at 4:10 PM.
//

import SwiftUI

struct LocationHistoryView: View {
    @Binding var locationHistory: [String]
    @Binding var editing: Bool
    
    init(_ locationHistory: Binding<[String]>, _ editing: Binding<Bool>) {
        self._locationHistory = locationHistory
        self._editing = editing
    }
    
    var body: some View {
        ScrollView {
            ForEach(locationHistory, id: \.self) { location in
                LocationHistoryItem {
                    switch editing {
                        case true:
                            HStack {
                                Button {
                                    locationHistory.removeAll { $0 == location }
                                } label: {
                                    Image(systemName: "trash")
                                        .fontWeight(.regular)
                                }
                                Text(location)
                                Spacer()
                            }
                        default:
                            Text(location)
                    }
                }
            }
        }
    }
}

struct LocationHistoryItem<Content: View>: View {
    @State private var selected: Bool = false
    let content: Content
    
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack {
            content
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .truncationMode(.tail)
            Spacer()
        }
    }
}
