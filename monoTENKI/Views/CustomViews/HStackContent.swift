//
//  HStackContent.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/17/25 at 9:03 PM.
//

import SwiftUI

struct HStackContent<Content: View>: View {
    let alignment: HorizontalAlignment
    var content: () -> Content
    
    init(orientation: HorizontalAlignment, _ content: @escaping () -> Content) {
        self.alignment = orientation
        self.content = content
    }
    
    var body: some View {
        HStack {
            if alignment == .leading {
                content()
                Spacer()
            } else {
                Spacer()
                content()
            }
        }
    }
}
