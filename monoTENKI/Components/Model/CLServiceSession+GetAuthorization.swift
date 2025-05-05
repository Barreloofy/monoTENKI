//
//  CLServiceSession+GetAuthorization.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/1/25 at 2:48 PM.
//

import CoreLocation
// MARK: - Convenience method
extension CLServiceSession {
  /// Returns true if some level of location authorization was granted otherwise false,
  /// if location authorization is undetermined, prompts for permission
  static func getAuthorizationStatus(
    session: CLServiceSession = CLServiceSession(authorization: .whenInUse)
  ) async -> Bool {
    let serviceStream = CLServiceSession(authorization: .whenInUse)

    do {
      for try await diagnostic in serviceStream.diagnostics where !diagnostic.authorizationRequestInProgress {
        return !diagnostic.authorizationDenied
      }
    } catch {
      return false
    }

    return false
  }
}
