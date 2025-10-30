import Foundation
import UIKit
import SwiftUI

//struct FlowLayout<Content: View>: View {
//    let alignment: HorizontalAlignment
//    let spacing: CGFloat
//    let content: () -> Content
//    
//    init(alignment: HorizontalAlignment = .leading,
//         spacing: CGFloat = 8,
//         @ViewBuilder content: @escaping () -> Content) {
//        self.alignment = alignment
//        self.spacing = spacing
//        self.content = content
//    }
//    
//    var body: some View {
//        GeometryReader { geometry in
//            self.generateContent(in: geometry)
//        }
//        .fixedSize(horizontal: false, vertical: true)
//    }
//    
//    func generateContent(in geometry: GeometryProxy) -> some View {
//        var width: CGFloat = 0
//        var height: CGFloat = 0
//        
//        return ZStack(alignment: Alignment(horizontal: alignment, vertical: .top)) {
//            content()
//                .alignmentGuide(.leading) { d in
//                    if (abs(width - d.width) > geometry.size.width) {
//                        width = 0
//                        height -= d.height + spacing
//                    }
//                    let result = width
//                    if d.width != 0 { width -= d.width + spacing }
//                    return result
//                }
//                .alignmentGuide(.top) { d in
//                    let result = height
//                    if d.width != 0 { height = result }
//                    return result
//                }
//        }
//    }
//}

struct TagView: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14))
            Text(text)
                .font(.system(size: 15, weight: .medium))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.3))
        .foregroundColor(.white)
        .clipShape(Capsule())
    }
}


struct FlowRowsView: View {
    let tags: [String]
    let horizontalSpacing: CGFloat = 12
    let verticalSpacing: CGFloat = 12
    
    @State private var totalHeight = CGFloat.zero

    var body: some View {
        VStack(alignment: .leading, spacing: verticalSpacing) {
            // Build each row
            ForEach(generateRows(), id: \.self) { row in
                HStack(spacing: horizontalSpacing) {
                    ForEach(row, id: \.self) { tag in
                        TagView(text: tag)
                    }
                }
            }
        }
    }
    
    // Split items into rows based on screen width
    private func generateRows() -> [[String]] {
        var rows: [[String]] = [[]]
        var currentRowWidth: CGFloat = 0
        let screenWidth = UIScreen.main.bounds.width - 32 // adjust for padding
        
        for tag in tags {
            let font = UIFont.systemFont(ofSize: 15, weight: .medium)
            let tagWidth = (tag as NSString).size(withAttributes: [.font: font]).width + 14*2 + 18 // padding + icon
            if currentRowWidth + tagWidth + horizontalSpacing > screenWidth {
                rows.append([tag])
                currentRowWidth = tagWidth + horizontalSpacing
            } else {
                rows[rows.count - 1].append(tag)
                currentRowWidth += tagWidth + horizontalSpacing
            }
        }
        return rows
    }
}

