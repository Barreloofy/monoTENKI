//
//  CLServiceSession+GetAuthorization.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/1/25 at 2:48 PM.
//

import CoreLocation

extension CLServiceSession {
  /// Queries the current authorization status.
  ///
  /// - Note: If location authorization is undetermined, prompts for permission.
  ///
  /// - Parameter session: The `CLServiceSession` to use, the default is `whenInUse`.
  /// - Returns: A boolean indicating whether some level of authorization was granted.
  static func getAuthorizationStatus(
    session: CLServiceSession = CLServiceSession(authorization: .whenInUse)) async -> Bool {
      guard
        let authorized = try? await session.diagnostics
          .first(where: { !$0.authorizationRequestInProgress })
          .map({ !$0.authorizationDenied })
      else { return false }

      return authorized
    }
}
