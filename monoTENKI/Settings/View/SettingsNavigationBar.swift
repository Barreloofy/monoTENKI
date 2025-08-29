//
// SettingsNavigationBar.swift
// monoTENKI
//
// Created by Barreloofy on 7/27/25 at 1:22 PM
//

import SwiftUI

struct SettingsNavigationBar: View {
  @Environment(\.isPresented) private var isPresented
  @Environment(\.dismiss) private var dismiss
  @Environment(SettingsController.self) private var settingsController

  let title: String

  var body: some View {
    Row(
      leading: {
        Button(
          action: { dismiss() },
          label: {
            Image(systemName: "chevron.backward")
              .fontWeight(.regular)
          })
      },
      center: { Text(title) },
      trailing: {
        Button(
          action: { settingsController() },
          label: {
            Image(systemName: "xmark")
              .fontWeight(.regular)
          })
      })
    .configureTopBar()
    .opacity(!isPresented ? 0 : 1)
  }
}
