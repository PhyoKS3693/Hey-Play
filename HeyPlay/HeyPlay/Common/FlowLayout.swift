import Foundation
import UIKit
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
        .fixedSize(horizontal: false, vertical: true)
    }
    
    func generateContent(in geometry: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        return ZStack(alignment: Alignment(horizontal: alignment, vertical: .top)) {
            content()
                .alignmentGuide(.leading) { d in
                    if (abs(width - d.width) > geometry.size.width) {
                        width = 0
                        height -= d.height + spacing
                    }
                    let result = width
                    if d.width != 0 { width -= d.width + spacing }
                    return result
                }
                .alignmentGuide(.top) { d in
                    let result = height
                    if d.width != 0 { height = result }
                    return result
                }
        }
    }
}
