//
//  MovieDetailView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 15/10/2025.
//

import Foundation
import SwiftUI

struct MovieDetailView : View {
    @State var tapTrailer : Bool = true
    @State var tapRecommend : Bool = false
    @State var tapEpisodes : Bool = false
    @State var detailType : DetailType = .series
    @State private var isSticky = false
    @State private var scrollOffset: CGFloat = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 50)
            CustomNavBar(onBack: {
                presentationMode.wrappedValue.dismiss()
            })
            
            if isSticky {
                SeriesAndTrailerAndRecommendView(
                    tapTrailer: $tapTrailer,
                    tapRecommend: $tapRecommend,
                    tapEpisodes: $tapEpisodes,
                    detailType: $detailType
                )
            }
                ScrollView {
                    ZStack(alignment: .bottom, content: {
                        MovieDetailTopView()
                        MovieDetailInfoView(
                            detailType: $detailType
                        )
                        .padding(.bottom , 15)
                    })
                    
                    SeriesAndTrailerAndRecommendView(
                        tapTrailer: $tapTrailer,
                        tapRecommend: $tapRecommend,
                        tapEpisodes: $tapEpisodes,
                        detailType: $detailType
                    )
                    MovieDetailBottomView(
                        tapTrailer: $tapTrailer,
                        tapRecommend: $tapRecommend,
                        tapEpisodes: $tapEpisodes,
                        detailType: $detailType
                    )
                    
                    
                    GeometryReader { geo in
                        Color.clear
                            .preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: geo.frame(in: .global).minY
                            )
                    }
                    .frame(height: 0)
                    
                }
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                    print("Scroll offset: \(scrollOffset)")
                    if tapRecommend {
                        self.isSticky = scrollOffset <= 1590
                    }
                    else if tapTrailer || tapEpisodes {
                        self.isSticky = false
                    }
                   
                }
            
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
    
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


#Preview {
    MovieDetailView()
}
