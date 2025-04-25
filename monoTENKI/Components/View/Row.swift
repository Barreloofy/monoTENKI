//
//  Row.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/24/25.
//

import SwiftUI

struct Row<
  ContentLeading,
  ContentCenter,
  ContentTrailing
>: View where
ContentLeading: View, ContentCenter: View, ContentTrailing: View {
  @ViewBuilder let leading: ContentLeading
  @ViewBuilder let center: ContentCenter
  @ViewBuilder let trailing: ContentTrailing

  var body: some View {
    ZStack {
      AlignedHStack(alignment: .leading) { leading }

      center

      AlignedHStack(alignment: .trailing) { trailing }
    }
  }
}
