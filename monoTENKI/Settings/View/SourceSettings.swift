//
// SourceSettings.swift
// monoTENKI
//
// Created by Barreloofy on 7/27/25 at 1:51 PM
//

import SwiftUI

struct SourceSettings: View {
  @AppStorage(.key(.apiSourceInUse)) private var apiSourceInUse = APISource.weatherAPI

  var body: some View {
    SettingsDetailView(
      category: "Source",
      icon: "antenna.radiowaves.left.and.right",
      description: "Diffrent weather sources are more accurate in diffrent regions. To improve accuracy, try selecting a diffrent source.",
      items: APISource.allCases,
      match: apiSourceInUse) { value in
        setEnvironment(.apiSourceInUse, value: value)
      }
  }
}


#Preview {
  SourceSettings()
    .environment(SettingsController())
    .configureApp()
}
