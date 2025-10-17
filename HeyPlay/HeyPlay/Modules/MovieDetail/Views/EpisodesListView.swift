//
//  EpisodesListView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 17/10/2025.
//

import Foundation
import SwiftUI

struct EpisodesListView : View {
    var episodeCount = 10
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10, content: {
                ForEach(0..<episodeCount, id: \.self) { row in
                    EpisodeItemView()
                }
            })
            .padding()
        }
        .background(Color.grey)
        .cornerRadius(15)
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct EpisodeItemView : View {
    var episodeName : String = "Episode 1"
    var description : String = "အန်တီက အကယ်ဒမီဆုရအောင် ကြိုးစားလာခဲ့တာ... "
    var body: some View {
        HStack(spacing: 10, content: {
            Image("series")
                .resizable()
                .frame(width: 120 , height: 70)
            
            EpisodeInfoView(
                episodeName: episodeName,
                description: description
            )
            
            Button {
                
            } label: {
                Image("ic.series.play")
                    .resizable()
                    .frame(width: 30 , height: 30)
            }

        })
        .padding(.all , 10)
        .background(Color.castBg)
        .cornerRadius(15)
        
    }
}

struct EpisodeInfoView : View {
    var episodeName : String = ""
    var description : String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text(episodeName)
                .font(FontUtility.regularFont(size: 12))
                .foregroundColor(.white)
            
            Text(description)
                .font(FontUtility.regularFont(size: 10))
                .foregroundColor(Color.castType)
        })
    }
}

#Preview {
    EpisodesListView()
}
