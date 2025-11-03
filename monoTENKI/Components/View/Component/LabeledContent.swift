//
// LabeledContent+Init.swift
// monoTENKI
//
// Created by Barreloofy on 10/31/25 at 8:43 PM
//

import SwiftUI

extension LabeledContent where Label: View, Content: View {
  init<Title, Icon>(
    @ViewBuilder content: () -> Content,
    @ViewBuilder title: () -> Title,
    @ViewBuilder icon: () -> Icon)
  where
    Title: View,
    Icon: View,
    Label == SwiftUI.Label<Title, Icon>
  {
    self.init(content: content) {
      Label(title: title, icon: icon)
    }
  }
}
