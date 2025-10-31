//
// SettingsRow.swift
// monoTENKI
//
// Created by Barreloofy on 10/31/25 at 6:08 PM
//

import SwiftUI

struct SettingsRow<
  Title,
  Icon,
  Content
>: View
where
  Content: View,
  Title: View,
  Icon: View
{
  @ViewBuilder let title: () -> Title
  @ViewBuilder let icon: () -> Icon
  @ViewBuilder let content: () -> Content

  var body: some View {
    LabeledContent(content: content) {
      Label(title: title, icon: icon)
    }
  }
}
