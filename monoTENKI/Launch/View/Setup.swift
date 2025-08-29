//
//  Setup.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/24/25 at 12:24 PM.
//

import SwiftUI
import CoreLocation

struct Setup: View {
  @Environment(LocationAggregate.self) private var locationAggregate
  
  @AppStorage(StorageKeys.presentSearch.rawValue) private var presentSearch = false
  
  @Binding var setupCompleted: Bool
  
  var body: some View {
    VStack {
      Group {
        Image(systemName: "location.fill")
          .primaryFont()
          .offset(y: -25)
        
        Text("Accurate weather")
        
        Text("Location is used to provide the most accurate weather")
          .font(.footnote)
          .fontWeight(.medium)
      }
      .lineLimit(nil)
      .offset(y: -25)
      
      VStack {
        Button("Grand access") {
          Task {
            if await CLServiceSession.getAuthorizationStatus() {
              locationAggregate.trackLocation = true
            } else {
              presentSearch = true
            }
          }
        }
        
        Button("Deny access") { presentSearch = true }
          .sheet(isPresented: $presentSearch) {
            Search(setup: true)
              .interactiveDismissDisabled()
              .sheetConfiguration()
          }
      }
      .buttonStyle(.permission)
      .fixedSize()
      .offset(y: 150)
    }
    .onChange(of: locationAggregate.location) { setupCompleted = true }
  }
}


#Preview {
  Setup(setupCompleted: .constant(false))
    .environment(LocationAggregate())
}
