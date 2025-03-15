//
//  UnitItem.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/14/25 at 11:43 PM.
//

import SwiftUI

extension UnitRow {
  struct UnitItem: View {
    let text: String
    @Binding var isOn: Bool
    let reversed: Bool

    private var isSelected: Bool {
      if reversed {
        return isOn ? false : true
      }
      else {
        return isOn ? true : false
      }
    }

    var body: some View {
      Text(text)
        .foregroundStyle(isSelected ? .white : .gray)
        .overlay(alignment: .bottom) {
          isSelected ? Rectangle().frame(height: 2) : nil
        }
        .onTapGesture {
          isOn = reversed ? false : true
        }
    }
  }
}
