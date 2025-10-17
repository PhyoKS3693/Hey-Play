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
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0, content: {
            Spacer()
                .frame(height: 50)
            CustomNavBar(onBack: {
                presentationMode.wrappedValue.dismiss()
            })
                .background(Color.black)
            ScrollView(content: {
                VStack {
                    ZStack(alignment: .top, content: {
                        MovieDetailTopView()
                        VStack {
                            Spacer()
                            MovieDetailInfoView(
                                detailType: $detailType
                            )
                        }
                        .padding(.bottom , 10)
                    })
                    .frame(height: 400)
                    
                    MovieDetailBottomView(
                        tapTrailer: $tapTrailer,
                        tapRecommend: $tapRecommend,
                        tapEpisodes: $tapEpisodes,
                        detailType: $detailType
                    )
                }
            })
            Spacer()
                .frame(height: 50)
        })
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}



#Preview {
    MovieDetailView()
}
