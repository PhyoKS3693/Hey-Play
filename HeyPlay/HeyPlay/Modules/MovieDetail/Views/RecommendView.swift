//
//  RecommendView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 16/10/2025.
//

import Foundation
import SwiftUI
import Kingfisher

enum PackType : String {
    case vip
    case free
    
    func getTitle() -> String{
        switch self {
        case .vip:
            return "VIP".localized()
        case .free:
            return "FREE".localized()
        }
    }
    
    func getImage() -> Image {
        switch self {
        case .vip:
            return Image("ic-vip")
        case .free:
            return Image("ic-free")
        }
    }
}
@available(iOS 14.0, *)
struct RecommendView : View {
    var movies: [Movie] = []
    let columns = 3
    var onMovieTapped: ((Int, Bool) -> Void)?

    private var items: [Movie] {
        movies.isEmpty ? [] : movies
    }

    var body: some View {
        VStack(spacing: 10) {
            if movies.isEmpty {
                // Placeholder items
                ForEach(0..<7, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<columns, id: \.self) { _ in
                            RecommendItemView()
                        }
                    }
                }
            } else {
                ForEach(0..<rowsCount(), id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<columns, id: \.self) { column in
                            if let movie = movieAt(row: row, column: column) {
                                RecommendItemView(
                                    imageURL: movie.fullImageURL,
                                    movieTitle: movie.name ?? "Untitled",
                                    packType: movie.isVIP ? .vip : .free
                                )
                                .onTapGesture {
                                    onMovieTapped?(movie.id, movie.isSeries)
                                }
                            } else {
                                Color.clear
                                    .frame(width: (UIScreen.main.bounds.width - 20) / 3, height: 190)
                            }
                        }
                    }
                }
            }
        }
        .background(Color.black)
    }

    func rowsCount() -> Int {
        (movies.count + columns - 1) / columns
    }

    func movieAt(row: Int, column: Int) -> Movie? {
        let index = row * columns + column
        return index < movies.count ? movies[index] : nil
    }
}

#if DEBUG
@available(iOS 14.0, *)
struct RecommendView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendView()
    }
}
#endif


@available(iOS 14.0, *)
struct RecommendItemView : View {
    var imageURL: String = ""
    var movieTitle: String = "Movie Title"
    var packType: PackType = .free

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                if let url = URL(string: imageURL), !imageURL.isEmpty {
                    KFImage(url)
                        .placeholder {
                            Image("image3")
                                .resizable()
                                .frame(height: 150)
                                .cornerRadius(10)
                        }
                        .resizable()
                        .frame(height: 150)
                        .cornerRadius(10)
                } else {
                    Image("image3")
                        .resizable()
                        .frame(height: 150)
                        .cornerRadius(10)
                }
                VStack {
                    Spacer()
                    HStack {
                        PackageType(type: packType)
                        Spacer()
                    }
                }
                .padding(.leading , 10)
                .padding(.bottom , 20)
            }

            HStack {
                Text(movieTitle)
                    .font(FontUtility.subHeadline())
                    .foregroundColor(.white)
                    .lineLimit(1)
                Spacer()
            }
            .padding(.all, 3)
        }
        .frame(width: (UIScreen.main.bounds.width - 20) / 3, height: 190)
        .background(Color.black)
    }
}

@available(iOS 14.0, *)
struct PackageType : View {
    var type : PackType = .free
    var body: some View {
        ZStack {
            HStack(spacing: 5, content: {
                type.getImage()
                    .resizable()
                    .frame(width: 16 , height: 16)
                Text(type.getTitle())
                    .font(FontUtility.smallText4())
                    .foregroundColor(.white)
            })
            .padding(.all , 5)
        }
        .frame(width: 38 , height: 22)
        .background(
            ZStack {
                // MARK: Blurred background card
                BlurView(style: .systemUltraThinMaterialDark)
                    .cornerRadius(11)

                // White overlay with 4% opacity
                Color.white.opacity(0.04)
                    .cornerRadius(11)
            }
        )
        .cornerRadius(11)
    }
}

#if DEBUG
@available(iOS 14.0, *)
struct RecommendItemView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendItemView()
    }
}
#endif
