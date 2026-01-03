//
//  CLLocationUpdate+GetAuthorization.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/1/25 at 2:48 PM.
//

import CoreLocation

extension CLLocationUpdate {
  /// Returns the current authorization status.
  ///
  /// - Note: If location authorization is undetermined, prompts for permission.
  ///
  /// - Returns: A boolean indicating whether some level of authorization was granted.
  nonisolated
  static func getAuthorization() async throws -> Bool {
    let updates = CLLocationUpdate.liveUpdates()
      .filter { !$0.authorizationRequestInProgress }
      .map { !$0.authorizationDenied }

    return try await updates.first { $0 } ?? false
  }
}
