//
//  FlowLayout.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 24/10/2025.
//

import Foundation
import SwiftUI

struct FlowLayout<Content: View>: View {
    let alignment: HorizontalAlignment
    let spacing: CGFloat
    let content: () -> Content

    init(alignment: HorizontalAlignment = .leading,
         spacing: CGFloat = 8,
         @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0

        return ZStack(alignment: Alignment(horizontal: alignment, vertical: .top)) {
            content()
                .alignmentGuide(.leading) { d in
                    if (width + d.width > geometry.size.width) {
                        width = 0
                        height -= d.height + spacing
                    }
                    let result = width
                    width += d.width + spacing
                    return result
                }
                .alignmentGuide(.top) { _ in
                    let result = height
                    return result
                }
        }
    }
}


