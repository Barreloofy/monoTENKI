//
//  APISource.swift
//  monoTENKI
//
//  Created by Barreloofy on 5/5/25.
//

import SwiftUI

extension EnvironmentValues {
  @Entry var apiSource = APISource.weatherApi
}


enum APISource: String {
  case weatherApi
  case accuWeather
}
