//
//  HourForecast.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/2/25 at 4:33 PM.
//

import SwiftUI

struct HourForecast: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  @State private var hourID: Date?

  let hours: Hours

  private var rowHeight: CGFloat {
    horizontalSizeClass == .compact ? 30 : 45
  }

  private func calculateRowSpacing(containerHeight: CGFloat) -> CGFloat {
    let verticalSafeArea = rowHeight
    let contentHeight = rowHeight * CGFloat(hours.count)
    let spacingHeight = containerHeight - (verticalSafeArea + contentHeight)

    return spacingHeight / CGFloat(hours.count)
  }

  var body: some View {
    GeometryReader { proxy in
      VStack(spacing: calculateRowSpacing(containerHeight: proxy.size.height)) {
        ForEach(hours) { hour in
          Row(
            leading: { Text(hour.time.formatted(.shortenedAndTimeZoneNeutral)) },
            center: {
              WeatherIcon(
                name: hour.condition,
                isDay: hour.isDay,
                usage: .custom(rowHeight))
            },
            trailing: { TemperatureView(hour.temperatureCelsius) })
          .overviewFont()
          .contentShape(Rectangle())
          .onTapGesture { hourID = hour.time }
        }
      }
      .enabled(hourID == nil)

      HourDetailPage(id: $hourID, hours: hours)
    }
    .animation(reduceMotion ? nil : .easeInOut(duration: 0.75), value: hourID)
    .sensoryFeedback(.impact, trigger: hourID)
  }
}
