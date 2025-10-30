//
//  MovieDetailBottomView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 15/10/2025.
//

import Foundation
import SwiftUI

struct MovieDetailBottomView : View {
    @Binding var tapTrailer : Bool
    @Binding var tapRecommend : Bool
    @Binding var tapEpisodes : Bool
    @Binding var detailType : DetailType
    
    var body: some View {
        ScrollView {
            VStack(content: {
                if tapEpisodes {
                    EpisodesListView()
                }
                
                if tapRecommend {
                    RecommendView()
                }
                
                if tapTrailer {
                    ZStack {
                        VStack {
                            MovieDetailDescriptionView()
                            CastView()
                        }
                    }
                    .background(Color.grey)
                    .cornerRadius(20)
                }
                Spacer()
            })
        }
        .background(Color.black)
        
    }
}

struct SeriesAndTrailerAndRecommendView : View {
    @Binding var tapTrailer : Bool
    @Binding var tapRecommend : Bool
    @Binding var tapEpisodes : Bool
    @Binding var detailType : DetailType
    var body: some View {
            HStack(spacing: 16) {
                
                if detailType == .series {
                    Button(action: {
                        tapEpisodes = true
                        tapTrailer = false
                        tapRecommend = false
                    }) {
                        Text("Episodes".localized())
                            .font(FontUtility.body1())
                        .foregroundColor(.white)
                        
                    }
                    .frame(maxWidth: 150, minHeight: 40)
                    .background(tapEpisodes ? Color.primaryBg : Color.recommendBG)
                    .cornerRadius(25)
                }
                
                Button(action: {
                    tapEpisodes = false
                    tapTrailer = true
                    tapRecommend = false
                }) {
                    Text("Trailers & Info".localized())
                        .font(FontUtility.body1())
                    .foregroundColor(.white)
                    
                }
                .frame(maxWidth: 150, minHeight: 40)
                .background(tapTrailer ? Color.primaryBg : Color.recommendBG)
                .cornerRadius(25)
                
                Button(action: {
                    tapEpisodes = false
                    tapTrailer = false
                    tapRecommend = true
                }) {
                    Text("Recommend".localized())
                        .font(FontUtility.body1())
                    .foregroundColor(.white)
                    
                }
                .frame(maxWidth: 150, minHeight: 40)
                .background(tapRecommend ? Color.primaryBg : Color.recommendBG)
                .cornerRadius(20)
                
                Spacer()
            }
            .padding(.vertical , 10)
    }
}

struct MovieDetailDescriptionView : View {
    var body: some View {
        
        VStack {
            Image("image2")
                .resizable()
                .frame(height: 300)
                .cornerRadius(20)
            HStack {
                Text("Description".localized())
                    .font(FontUtility.headline2())
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.top , 10)
            
            Text("Watch live and new program every monthsWatch live and new program every monthsWatch live and new program every monthsWatch live and new program every monthsWatch live and new program every monthsWatch live and new program every months")
                .foregroundColor(.white)
                .font(FontUtility.body2())
        }
        .padding()
    }
}

#Preview {
    MovieDetailBottomView(
        tapTrailer: .constant(true),
        tapRecommend: .constant(false),
        tapEpisodes: .constant(false),
        detailType: .constant(.series)
    )
}
