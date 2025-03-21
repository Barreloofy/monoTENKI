//
//  DesignSystem.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/13/25 at 9:04 PM.
//

struct DesignSystem {
  struct AppText {
    struct SetupText {
      static let greetingsText = """
        Greetings fellow weather watcher! \
        first let's setup a few things  \
        before occupying ourselves with the more interesting things in life The Weather!
        """
      static let greetingsButton = "Get started"

      static let permissionText = """
        Grant localtion access to
        get the most accurate weather
        """
      static let permissionButtonGrand = "Grand permission"
      static let permissionButtonDeny = "No, thank you!"

      static let unitText = """
        One more thing, please choose
        your preferred weather unit:
        """
      static let unitButtonMetric = "Metric"
      static let unitButtonImperial = "Imperial"
    }
  }
}
