//
//  Search.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/25/25 at 12:09 PM.
//

import SwiftUI
import SwiftData
import CoreLocation

struct Search: View {
  enum SearchState {
    case presenting, queryFailed, permissionDenied
  }

  @Query(Location.descriptor, animation: .smooth(duration: 1)) private var history: Locations

  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @Environment(\.apiSource) private var apiSource
  @Environment(LocationAggregate.self) private var locationAggregate
  @StyleMode private var styleMode

  @State private var state = SearchState.presenting
  @State private var text = ""
  @State private var result = Locations()

  let setup: Bool

  private var displayedLocations: Locations {
    text.isEmpty ? history : result
  }

  var body: some View {
    NavigationStack {
      VStack(spacing: 10) {
        TextField(
          "",
          text: $text,
          prompt: Text("Search").foregroundStyle(styleMode))
        .textInputAutocapitalization(.characters)
        .multilineTextAlignment(.leading)
        .debounce(id: text) {
          do {
            state = .presenting
            switch apiSource {
            case .weatherAPI:
              result = try await Array(WeatherAPI.fetchSearch(for: text).prefix(10))
            case .accuWeather:
              result = try await Array(AccuWeather.fetchSearch(for: text).prefix(10))
            }
          } catch URLError.cancelled {
            return
          } catch {
            state = .queryFailed
          }
        }

        AlignedHStack(alignment: .leading) {
          Button(
            action: {
              Task {
                if await CLServiceSession.getAuthorizationStatus() {
                  locationAggregate.startTracking()
                  dismiss()
                } else {
                  state = .permissionDenied
                }
              }
            },
            label: { Label("CURRENT LOCATION", systemImage: "location.fill") })
        }
        .visible(!setup)

        switch state {
        case .presenting:
          ScrollView {
            LazyVStack(spacing: 0) {
              ForEach(displayedLocations) { result in
                AlignedHStack(alignment: .leading) {
                  Label(result.completeName, systemImage: "mappin.and.ellipse")
                    .onTapGesture {
                      result.accessDate = .now
                      modelContext.insert(result)
                      locationAggregate.stopTracking(result.coordinate)
                      dismiss()
                    }
                    .accessibilityAddTraits(.isSelected)
                }
                .swipeToDelete(isEnabled: text.isEmpty) { modelContext.delete(result) }
              }
            }
          }
          .scrollIndicators(.never)

        case .queryFailed:
          Text("""
          Search couldn't be completed, 
          check connection status
          """)
          .configureMessage()

        case .permissionDenied:
          Group {
            Text("""
            No permission to access location, 
            grand permission to receive the most accurate weather
            """)

            Link(
              "Open Settings",
              destination: URL(
                string: UIApplication.openSettingsURLString)!)
            .buttonStyle(.bordered)
          }
          .configureMessage()
        }

        Spacer()
      }
      .configureNavigationBar(enabled: !setup)
      .subtitleFont()
      .fontWeight(.medium)
      .padding()
      .animating(state, with: .smooth)
    }
  }
}


#Preview {
  Search(setup: false)
    .configureApp()
    .environment(LocationAggregate())
}
