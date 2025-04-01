//
//  CLServiceSession+GetAuthorization.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/1/25 at 2:48 PM.
//

import CoreLocation
// MARK: - Convenience method
extension CLServiceSession {
  /// Returns true if 'authorizationDenied' is false otherwise true, session has a default value of 'whenInUse' authorization
  ///
  /// Important, don't use this method to request Authorization use the Apple provided way instead:
  ///
  ///     let ServiceStream = CLServiceSession(authorization: .whenInUse)
  ///
  ///     for try await diagnostic in ServiceStream.diagnostics where !diagnostic.authorizationRequestInProgress  {
  ///       if diagnostic.authorizationDenied {
  ///         ...
  ///       } else {
  ///         ...
  ///       }
  ///       break
  ///     }
  ///
  static func getAuthorization(session: CLServiceSession = CLServiceSession(authorization: .whenInUse)) async -> Bool {
    let ServiceStream = CLServiceSession(authorization: .whenInUse)

    do {
      for try await diagnostic in ServiceStream.diagnostics {
        return diagnostic.authorizationDenied ? false : true
      }
    } catch {
      return false
    }

    return false
  }
}
