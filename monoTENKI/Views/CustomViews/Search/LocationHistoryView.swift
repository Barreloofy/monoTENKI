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
    @ObservedObject private var locationManager: LocationManager = LocationManager.shared
    @Binding var locationHistory: [LocationIdentity]
    @Binding var editing: Bool
    
    init(_ locationHistory: Binding<[LocationIdentity]>, _ editing: Binding<Bool>) {
        self._locationHistory = locationHistory
        self._editing = editing
    }
    
    var body: some View {
        ScrollView {
            ForEach(locationHistory.indices, id: \.self) { index in
                itemContent(editing, locationHistory[index])
            }
        }
    }
    
    @ViewBuilder private func itemContent(_ editing: Bool, _ location: LocationIdentity) -> some View {
        HStack {
            if editing {
                Button {
                    locationHistory.removeAll { $0 == location }
                } label: {
                    Image(systemName: "trash")
                        .fontWeight(.regular)
                }
                SearchItemView(location: location)
            }
            else {
                SearchItemView(location: location)
                    .onTapGesture {
                        weatherData.currentLocation = location.name
                        locationManager.trackLocation = false
                        locationHistory.swapAt(0, locationHistory.firstIndex(of: location)!)
                        dismiss()
                    }
            }
        }
    }
}
