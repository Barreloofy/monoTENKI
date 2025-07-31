//
//  APISource.swift
//  monoTENKI
//
//  Created by Barreloofy on 5/5/25.
//

import SwiftUI

enum APISource: String, CaseIterable, Identifiable {
  case weatherAPI
  case accuWeather

  var id: APISource { self }

  var accessibilityPronunciation: String {
    switch self {
    case .weatherAPI: "Weather A P I"
    case .accuWeather: "Accu Weather"
    }
  }
}


extension EnvironmentValues {
  @Entry var apiSource = APISource.weatherAPI
}


extension View {
  func apiSource(_ apiSource: APISource) -> some View {
    environment(\.apiSource, apiSource)
  }
}


extension Scene {
  func apiSource(_ apiSource: APISource) -> some Scene {
    environment(\.apiSource, apiSource)
  }
}
