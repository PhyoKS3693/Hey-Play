//
//  MovieDetailView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 15/10/2025.
//

import Foundation
import SwiftUI

struct MovieDetailView : View {
    @State var tapTrailer : Bool = false
    @State var tapRecommend : Bool = false
    var body: some View {
        VStack(spacing: 0, content: {
            Spacer()
                .frame(height: 50)
            CustomNavBar()
                .background(Color.black)
            ScrollView(content: {
                VStack {
                    ZStack(alignment: .top, content: {
                        MovieDetailTopView()
                        VStack {
                            Spacer()
                            MovieDetailInfoView()
                        }
                        .padding(.bottom , 10)
                    })
                    .frame(width: .infinity , height: 400)
                    
                    MovieDetailBottomView(
                        tapTrailer: $tapTrailer,
                        tapRecommend: $tapRecommend
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
