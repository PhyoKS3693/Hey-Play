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
    var body: some View {
        VStack {
            TrailerAndRecommendView(
                tapTrailer: $tapTrailer,
                tapRecommend: $tapRecommend
            )
            ZStack {
                VStack {
                    MovieDetailDescriptionView()
                    CastView()
                }
            }
            .background(Color.grey)
            .cornerRadius(20)
            .padding(.horizontal , 10)
            
        }
        
    }
}

struct TrailerAndRecommendView : View {
    @Binding var tapTrailer : Bool
    @Binding var tapRecommend : Bool
    var body: some View {
            HStack(spacing: 16) {
                Button(action: {
                    tapTrailer = true
                }) {
                    Text("Trailers & Info".localized())
                    .font(FontUtility.regularFont(size: 13))
                    .foregroundColor(.white)
                    
                }
                .frame(maxWidth: 150, minHeight: 40)
                .background(Color.primaryBg)
                .cornerRadius(25)
                
                Button(action: {
                    tapRecommend = true
                }) {
                    Text("Recommend".localized())
                    .font(FontUtility.regularFont(size: 13))
                    .foregroundColor(.white)
                    
                }
                .frame(maxWidth: 150, minHeight: 40)
                .background(Color.recommendBG)
                .cornerRadius(20)
                
                Spacer()
            }
            .padding()
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
                    .font(FontUtility.largeTitleFont())
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.top , 10)
            
            Text("Watch live and new program every monthsWatch live and new program every monthsWatch live and new program every monthsWatch live and new program every monthsWatch live and new program every monthsWatch live and new program every months")
                .foregroundColor(.white)
                .font(FontUtility.normalFont())
        }
        .padding()
        
        
    }
}

#Preview {
    MovieDetailBottomView(
        tapTrailer: .constant(false),
        tapRecommend: .constant(false)
    )
}
