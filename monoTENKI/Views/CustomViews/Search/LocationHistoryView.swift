//
//  LocationHistoryView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/31/25 at 4:10 PM.
//

import SwiftUI

struct LocationHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var weatherData: WeatherData
    @ObservedObject private var locationManager: LocationManager
    @Binding private var locationHistory: [LocationKey]
    @Binding private var editing: Bool
    
    init(locationHistory: Binding<[LocationKey]>, isEditing: Binding<Bool>) {
        self._locationHistory = locationHistory
        self._editing = isEditing
        self.locationManager = LocationManager.shared
    }
    
    var body: some View {
        ScrollView {
            ForEach(locationHistory.indices, id: \.self) { index in
                createHistoryBlock(for: locationHistory[index])
            }
        }
    }
    
    
    @ViewBuilder private func createHistoryBlock(for location: LocationKey) -> some View {
        HStack {
            if editing {
                Button {
                    locationHistory.removeAll { $0 == location }
                } label: {
                    Image(systemName: "trash")
                        .fontWeight(.regular)
                }
                
                SearchItem(location: location)
            } else {
                SearchItem(location: location)
                    .onTapGesture {
                        weatherData.currentLocation = location.name
                        locationManager.trackLocation = false
                        dismiss()
                        locationHistory.removeAll(where: { $0 == location })
                        locationHistory.insert(location, at: 0)
                    }
            }
        }
    }
}
