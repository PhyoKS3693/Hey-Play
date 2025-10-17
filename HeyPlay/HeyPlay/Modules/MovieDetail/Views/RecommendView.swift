//
//  RecommendView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 16/10/2025.
//

import Foundation
import SwiftUI

enum PackType : String {
    case vip
    case free
    
    func getTitle() -> String{
        switch self {
        case .vip:
            return "VIP".localized()
        case .free:
            return "FREE".localized()
        }
    }
    
    func getImage() -> Image {
        switch self {
        case .vip:
            return Image("ic-vip")
        case .free:
            return Image("ic-free")
        }
    }
}
struct RecommendView : View {
    let items = Array(1...20)
    let columns = 3
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(0..<rowsCount(), id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(0..<columns, id: \.self) { column in
                                RecommendItemView()
                            }
                        }
                    }
                }
            }
        }
        .background(Color.black)
        
    }
    
    func rowsCount() -> Int {
        (items.count + columns - 1) / columns
    }
    
    func itemAt(row: Int, column: Int) -> Int? {
        let index = row * columns + column
        return index < items.count ? items[index] : nil
    }
}

#Preview {
    RecommendView()
}


struct RecommendItemView : View {
    var imageStr : String = "image3"
    var movieTile : String = "Movie Title"
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Image(imageStr)
                    .resizable()
                    .frame(height: 150)
                    .cornerRadius(10)
                VStack {
                    Spacer()
                    HStack {
                        PackageType(type: .vip)
                        Spacer()
                    }
                }
                .padding(.leading , 10)
                .padding(.bottom , 20)
                
            }
            
            HStack {
                Text(movieTile)
                    .font(FontUtility.regularFont(size: 12))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.all, 3)
        }
        .frame(width: (UIScreen.main.bounds.width - 20) / 3, height: 190)
        .background(Color.black)
    }
}

struct PackageType : View {
    var type : PackType = .free
    var body: some View {
        ZStack {
            HStack(spacing: 5, content: {
                type.getImage()
                    .resizable()
                    .frame(width: 16 , height: 16)
                Text(type.getTitle())
                    .font(FontUtility.regularFont(size: 6))
                    .foregroundColor(.white)
            })
            .padding(.all , 5)
        }
        .frame(width: 50 , height: 22)
        .background(
            // MARK: Blurred background card
            BlurView(style: .systemUltraThinMaterialDark)
                .cornerRadius(11)
                .shadow(radius: 8)
        )
    }
}

#Preview {
    RecommendItemView()
}
