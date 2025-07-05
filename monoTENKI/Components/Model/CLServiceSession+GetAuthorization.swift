//
//  CLServiceSession+GetAuthorization.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/1/25 at 2:48 PM.
//

import CoreLocation

// Convenience method
extension CLServiceSession {
  /// Returns true if some level of location authorization was granted otherwise false,
  /// if location authorization is undetermined, prompts for permission.
  static func getAuthorizationStatus(
    session: CLServiceSession = CLServiceSession(authorization: .whenInUse)) async -> Bool {
      let authorizationStatus = try? await session.diagnostics.first { !$0.authorizationRequestInProgress }
      guard let authorizationStatus = authorizationStatus else { return false }
      return !authorizationStatus.authorizationDenied
    }
}
