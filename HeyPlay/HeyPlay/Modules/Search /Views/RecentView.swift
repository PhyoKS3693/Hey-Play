//
//  RecentView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 24/10/2025.
//

import Foundation
import SwiftUI

struct RecentView : View {
    var body: some View {
        VStack {
            RecentTopView()
            RecentCollectionView()
        }
    }
}

struct RecentTopView : View {
    var body: some View {
        HStack {
            Text("Recent".localized())
                .foregroundColor(.white)
                .font(FontUtility.heading2())
            
            Spacer()
            
            Button {
                
            } label: {
                Text("Clear All".localized())
                    .foregroundColor(.red)
                    .font(FontUtility.body2())
            }
            

            
        }
        .padding(.horizontal , 10)
        .background(Color.black)
    }
}

struct RecentCollectionView : View {
    let names = [
        "Aung Ye Lin", "Nay Toe", "Mg",
        "Kyaw Ye Aung", "Thet Mon Myint",
        "Pyay Ti Oo", "Yan Aung"
    ]
    
    var body: some View {
        FlowLayout(alignment: .leading, spacing: 10) {
            ForEach(names, id: \.self) { name in
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14, weight: .medium))
                    Text(name)
                        .font(.system(size: 14, weight: .medium))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.gray.opacity(0.25))
                .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color.black)
    }
}

#Preview {
    RecentView()
}
