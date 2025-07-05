//
//  APISource.swift
//  monoTENKI
//
//  Created by Barreloofy on 5/5/25.
//

import SwiftUI

// The environment-value that serves as the source of truth for whether to use weatherAPI or accuWeather
extension EnvironmentValues {
  @Entry var apiSource = APISource.weatherAPI
}


enum APISource: String, CaseIterable {
  case weatherAPI
  case accuWeather
}
