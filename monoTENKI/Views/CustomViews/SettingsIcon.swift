//
//  SettingsIcon.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/2/25 at 9:26 PM.
//

import SwiftUI

struct SettingsIcon: View {
    let width: CGFloat
    let height: CGFloat
    let style: Color
    
    init(width: CGFloat = 100, height: CGFloat = 100, style: Color = .white) {
        self.width = width
        self.height = height
        self.style = style
    }
    
    var body: some View {
        Circumrhombus()
            .stroke()
            .contentShape(Circumrhombus())
            .foregroundStyle(style)
            .frame(width: width, height: height)
    }
    
    struct Circumrhombus: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.midX, rect.midY)
            path.addArc(center: center, radius: radius, startAngle: .zero, endAngle: .degrees(360), clockwise: true)
            path.closeSubpath()
            
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY * 0.333))
            path.addLine(to: CGPoint(x: rect.maxX * 0.666, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY * 0.666))
            path.addLine(to: CGPoint(x: rect.maxX * 0.333, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY * 0.333))
            path.closeSubpath()
            
            return path
        }
    }
}
