//
// Row.swift
// monoTENKI
//
// Created by Barreloofy on 4/24/25.
//

import SwiftUI

struct Row<
  ContentLeading: View,
  ContentCenter: View,
  ContentTrailing: View,
>: View {
  let leading: ContentLeading
  let center: ContentCenter
  let trailing: ContentTrailing

  init(
    @ViewBuilder leading: () -> ContentLeading = { EmptyView() },
    @ViewBuilder center: () -> ContentCenter = { EmptyView() },
    @ViewBuilder trailing: () -> ContentTrailing = {EmptyView() }) {
      self.leading = leading()
      self.center = center()
      self.trailing = trailing()
    }

  var body: some View {
    ZStack {
      AlignedHStack(alignment: .leading) { leading }

      center

      AlignedHStack(alignment: .trailing) { trailing }
    }
  }
}
