//
//  MostSearchView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 30/10/2025.
//

import Foundation
import SwiftUI

struct MostSearchView : View {
    @ObservedObject var viewModel: SearchViewModel

    var body: some View {
        if !viewModel.trendingSearches.isEmpty {
            VStack {
                MostSearchTopView(title: viewModel.trendingTitle)
                MostSearchTagCollectionView(searches: viewModel.trendingSearches, onTap: { query in
                    Task {
                        await viewModel.quickSearch(query: query)
                    }
                })
            }
        }
    }
}
struct MostSearchTopView : View {
    var title: String = ""

    var body: some View {
        HStack {
            Text(title.isEmpty ? "Most Search".localized() : title)
                .foregroundColor(.white)
                .font(FontUtility.heading2())

            Spacer()
        }
        .frame(height: 40)
        .padding(.horizontal , 10)
        .background(Color.black)
    }
}


struct MostSearchTagCollectionView: View {
    let searches: [String]
    let onTap: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            FlowRowsView(tags: searches, onTap: onTap)
                .padding(.horizontal)

            Spacer(minLength: 0)
        }
        .padding(.top, 16)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

