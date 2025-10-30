//
// SettingsDetailView.swift
// monoTENKI
//
// Created by Barreloofy on 9/18/25 at 4:01 PM
//

import SwiftUI

struct SettingsDetailView<T>:
  View
where
  T: RandomAccessCollection,
  T.Element: Identifiable,
  T.Element: Equatable,
  T.Element: RawRepresentable,
  T.Element.RawValue == String
{
  let category: String
  let icon: String
  let description: String
  let items: T
  let match: T.Element
  let action: (T.Element) -> Void

  var body: some View {
    VStack {
      VStack(spacing: 10) {
        Image(systemName: icon)
          .subheadlineFont()

        Text(category)
          .subtitleFont()

        Text(description)
          .footnoteFont()
      }
      .lineLimit(nil)
      .padding()
      .applyGlassEffectIfAvailable()
      .padding(25)

      List(items) { item in
        Button(
          action: { action(item) },
          label: {
            Label(item.rawValue, systemImage: item == match ? "checkmark" : "")
              .labelStyle(.trailing)
          })
        .listRowBackground(Color.clear)
      }
      .listStyle(.plain)
      .scrollDisabled(true)
    }
    .configureSettingsDetail()
    .sensoryFeedback(.impact, trigger: match)
  }
}


#Preview {
  SettingsDetailView(
    category: "Units",
    icon: "ruler.fill",
    description: "Select your preferred temperature unit to align weather information with your personal preferences.",
    items: MeasurementSystem.allCases,
    match: MeasurementSystem.metric,
    action: { _ in print("Hello, World!") })
  .configureApp()
  //.sheetController(SheetController())
}
