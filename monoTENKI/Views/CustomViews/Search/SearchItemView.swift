//
//  SearchItemView.swift
//  monoTENKI
//
//  Created by Barreloofy on 2/8/25 at 11:51 PM.
//

import SwiftUI

struct SearchItemView: View {
    let location: LocationKey
    
    var body: some View {
        HStack {
            Text(location.name)
                .layoutPriority(1)
            Text(location.country)
            Spacer()
        }
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .truncationMode(.tail)
    }
}
