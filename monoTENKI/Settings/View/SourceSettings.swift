//
// SourceSettings.swift
// monoTENKI
//
// Created by Barreloofy on 7/27/25 at 1:51 PM
//

import SwiftUI

struct SourceSettings: View {
  @AppStorage(StorageKeys.apiSourceInUse.rawValue) private var apiSourceInUse = APISource.weatherAPI

  var body: some View {
    VStack(spacing: 50) {
      SettingsNavigationBar(title: "Source")

      LazyVGrid(columns: .twoColumnLayout) {
        ForEach(APISource.allCases) { source in
          Text(source.rawValue)
            .selectedStyle(target: source, value: $apiSourceInUse)
            .accessibilityLabel(source.accessibilityPronunciation)
        }
      }

      Spacer()
    }
    .configureSettingsDetail()
  }
}
