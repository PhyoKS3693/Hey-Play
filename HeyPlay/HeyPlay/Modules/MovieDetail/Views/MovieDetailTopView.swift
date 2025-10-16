//
//  MovieDetailTopView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 15/10/2025.
//

import Foundation
import SwiftUI

struct MovieDetailTopView : View {
    var body: some View {
        Image("image2")
            .resizable()
            .frame(maxWidth: .infinity  , maxHeight: 400)
    }
}

struct MovieDetailInfoView : View {
    var body: some View {
        VStack(spacing: 16) {
            MovieTitleInfoView()
            MovieActionButtonsView()
        }
        .padding()
        .background(
            // MARK: Blurred background card
            BlurView(style: .systemUltraThinMaterialDark)
                .cornerRadius(20)
                .shadow(radius: 8)
        )
        .padding(.horizontal, 10)
    }
}

struct MovieTitleInfoView : View {
    var body: some View {
        // MARK: Movie title
        Text("ကြောက်သလို မမေ့နော်") // your title text
     .font(FontUtility.largeTitleFont())
            .foregroundColor(.white)
        
        // MARK: Details row
        HStack(spacing: 10) {
            Image("ic.calendar")
                .resizable()
                .frame(width: 20 , height: 20)
            Text("July, 2025")
                .font(FontUtility.normalFont())
                .foregroundColor(.white.opacity(0.8))
            
            Image("ic.time")
                .resizable()
                .frame(width: 20 , height: 20)
            Text("1 hr 30m")
                .font(FontUtility.normalFont())
                .foregroundColor(.white.opacity(0.8))
            
            Image("ic.type")
                .resizable()
                .frame(width: 20 , height: 20)
            Text("Comedy, Horror")
                .font(FontUtility.normalFont())
                .foregroundColor(.white.opacity(0.8))
            
        }
        .font(FontUtility.normalFont())
        .foregroundColor(.white.opacity(0.8))
    }
}

struct MovieActionButtonsView : View {
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                print("Play tapped")
            }) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Play")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: 40)
                .background(Color.primaryBg)
                .cornerRadius(25)
            }
            
            Button(action: {
                print("Watchlist tapped")
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Watchlist")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: 40)
                .background(Color.black.opacity(0.7))
                .cornerRadius(20)
            }
        }
    }
}

#Preview {
    MovieDetailTopView()
}
