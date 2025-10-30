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
    @ViewBuilder leading: () -> ContentLeading,
    @ViewBuilder center: () -> ContentCenter,
    @ViewBuilder trailing: () -> ContentTrailing) {
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


extension Row where ContentLeading == EmptyView {
  init(
    @ViewBuilder center: () -> ContentCenter,
    @ViewBuilder trailing: () -> ContentTrailing) {
      self.init(
        leading: { EmptyView() },
        center: center,
        trailing: trailing)
    }
}


extension Row where ContentTrailing == EmptyView {
  init(
    @ViewBuilder leading: () -> ContentLeading,
    @ViewBuilder center: () -> ContentCenter) {
      self.init(
        leading: leading,
        center: center,
        trailing: { EmptyView() })
    }
}
