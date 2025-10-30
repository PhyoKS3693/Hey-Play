//
//  MostSearchView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 30/10/2025.
//

import Foundation
import SwiftUI

struct MostSearchView : View {
    var body: some View {
        VStack {
            MostSearchTopView()
            MostSearchTagCollectionView()
        }
    }
}
struct MostSearchTopView : View {
    var body: some View {
        HStack {
            Text("Most Search".localized())
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
        .frame(height: 40)
        .padding(.horizontal , 10)
        .background(Color.black)
    }
}


struct MostSearchTagCollectionView: View {
    let tags = [
        "Aung Ye Lin", "Nay Toe", "Mg",
        "Kyaw Ye Aung", "Thet Mon Myint",
        "Pyay Ti Oo", "Yan Aung"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            FlowRowsView(tags: tags)
                .padding(.horizontal)
            
            Spacer(minLength: 0)
        }
        .padding(.top, 16)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

