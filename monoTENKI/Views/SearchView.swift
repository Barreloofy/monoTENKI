//
//  SearchView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 5:28 PM.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var weatherData: WeatherData
    @Environment(\.dismiss) private var dismiss
    @FocusState private var textFieldIsFocused: Bool
    @State private var text = ""
    @State private var locationHistory = [LocationIdentity]()
    @State private var locations = [Location]()
    @State private var editing = false
    @State private var showAlert = false
    private var locationManager = LocationManager.shared
    
    var body: some View {
        ZStack {
            VStack {
                ContentView
            }
            .font(.system(.title, design: .serif, weight: .bold))
            .foregroundStyle(.white)
            .padding()
            .background(.black)
            .onAppear {
                load()
            }
            .onChange(of: text) {
                fetchLocations()
            }
            .onChange(of: locationHistory) {
                save()
            }
            .blur(radius: showAlert ? 5 : 0)
            if showAlert {
                AlertView(show: $showAlert, title: "UH, OH", message: "SOMETHING WENT WRONG", actionMessage: "TAP TO RETRY")
            }
        }
    }
    
    @ViewBuilder private var ContentView: some View {
        ZStack {
            HStackContent(orientation: .leading) {
                Button {
                    editing.toggle()
                } label: {
                    Text("Edit")
                }
            }
            Text("Location")
            HStackContent(orientation: .trailing) {
                Button {
                    dismiss()
                } label: {
                    Text("X")
                }
            }
        }
        
        TextField("", text: $text)
            .searchTextField(text, _textFieldIsFocused)
            .focused($textFieldIsFocused)
            .disabled(showAlert ? true : false)
        
        HStackContent(orientation: .leading) {
            Button {
                fetchCurrentLocation()
            } label: {
                Label("CURRENT LOCATION", systemImage: "location.fill")
            }
        }
        .font(.system(.title2, design: .serif, weight: .bold))
        
        LocationList
    }
    
    @ViewBuilder private var LocationList: some View {
        if text.isEmpty {
            LocationHistoryView($locationHistory, $editing)
        }
        else {
            ScrollView {
                ForEach(locations) { location in
                    SearchItemView(location: LocationIdentity(name: location.name, country: location.country))
                        .onTapGesture {
                            weatherData.currentLocation = location.name
                            locationManager.trackLocation = false
                            updateLocationHistory(with: LocationIdentity(name: location.name, country: location.country))
                            dismiss()
                        }
                }
            }
        }
    }
    
    
    private func fetchLocations() {
        Task {
            do {
                guard !text.isEmpty else { return }
                locations = try await APIClient.fetch(service: .location, forType: [Location].self, text)
            } catch {
                showAlert = true
            }
        }
    }
    
    private func fetchCurrentLocation() {
        Task {
            do {
                guard let query = locationManager.stringLocation else { throw LocationManager.LocationError.managerError }
                let results = try await APIClient.fetch(service: .location, forType: [Location].self, query)
                guard let firstResult = results.first else { throw LocationManager.LocationError.locationNil }
                weatherData.currentLocation = firstResult.name
                locationManager.trackLocation = true
                dismiss()
            } catch {
                showAlert = true
            }
        }
    }
}

private extension SearchView {
    var documentsURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appending(path: "locationHistory")
    }
    var locationHistoryFile: URL {
        return documentsURL.appending(path: "history")
    }
    
    
    func save() {
        try? FileManager.default.createDirectory(at: documentsURL, withIntermediateDirectories: false)
        let data = try! JSONEncoder().encode(locationHistory)
        try! data.write(to: locationHistoryFile)
    }
    
    func load() {
        guard FileManager.default.isReadableFile(atPath: locationHistoryFile.path()) else { return }
        let data = try! Data(contentsOf: locationHistoryFile)
        locationHistory = try! JSONDecoder().decode([LocationIdentity].self, from: data)
    }
    
    func updateLocationHistory(with input: LocationIdentity) {
        for (index, location) in locationHistory.enumerated() {
            guard input == location else { continue }
            locationHistory.swapAt(0, index)
            save()
            return
        }
        locationHistory.insert(input, at: 0)
        save()
    }
}

#Preview {
    SearchView()
        .environmentObject(WeatherData())
}
