//
//  GuideView.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/14/25 at 12:42 PM.
//

import SwiftUI

extension SetupView {
  struct GuideView<LabelContent: View, ActionContent: View>: View {
    @ViewBuilder let label: LabelContent
    @ViewBuilder let action: ActionContent

    var body: some View {
      ZStack {
        Color(.black).opacity(0.98).ignoresSafeArea()
        VStack {
          label
            .padding(.bottom)
          action
        }
        .font(.system(.title2, design: .serif, weight: .bold))
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .padding(.bottom, 175)
        .padding(.horizontal)
      }
    }
  }
}
