//
//  RecentView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 24/10/2025.
//

import Foundation
import SwiftUI

struct RecentView : View {
    @ObservedObject var viewModel: SearchViewModel

    var body: some View {
        if !viewModel.recentSearches.isEmpty {
            VStack(spacing: 0) {
                RecentTopView()
                RecentTagCollectionView(searches: viewModel.recentSearches, onTap: { query in
                    Task {
                        await viewModel.quickSearch(query: query)
                    }
                })
            }
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
        .frame(height: 40)
        .padding(.horizontal , 10)
        .background(Color.black)
        
    }
}

struct RecentTagCollectionView: View {
    let searches: [String]
    let onTap: (String) -> Void

    var body: some View {
        FlowRowsView(tags: searches, onTap: onTap)
            .padding(.horizontal)
            .padding(.top, 16)
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}



