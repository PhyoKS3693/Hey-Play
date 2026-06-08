//
//  CastView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 15/10/2025.
//

import Foundation
import SwiftUI
import Kingfisher

@available(iOS 14.0, *)
struct CastView: View {
    var cast: [MovieArtist] = []

    var body: some View {
        VStack {
            HStack {
                Text("Cast".localized())
                    .font(FontUtility.headline2())
                    .foregroundColor(.white)

                Spacer()
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    if cast.isEmpty {
                        // Show placeholder items
                        ForEach(0..<8, id: \.self) { _ in
                            CastItemView()
                        }
                    } else {
                        ForEach(cast) { artist in
                            CastItemView(
                                title: artist.role ?? "Actor",
                                name: artist.name ?? "Unknown",
                                imageURL: artist.image ?? ""
                            )
                            .onAppear {
                                print("🎭 Cast: \(artist.name ?? "Unknown") - Image URL: \(artist.image ?? "NO URL")")
                            }
                        }
                    }
                }
                .padding(.bottom, 12)
            }
        }
        .padding(.top, 12)
        .padding(.horizontal, 12)
    }
}

@available(iOS 14.0, *)
struct CastItemView: View {
    var title: String = "Actor"
    var name: String = "Nyunt Win"
    var imageURL: String = ""

    var body: some View {
        Button(action: {
            print("Button Action")
        }, label: {
            HStack(spacing: 10, content: {
                if let url = URL(string: imageURL), !imageURL.isEmpty {
                    KFImage(url)
                        .placeholder {
                            Image("ic-user")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .cornerRadius(17.5)
                                .padding(.leading, 10)
                        }
                        .resizable()
                        .frame(width: 35, height: 35)
                        .cornerRadius(17.5)
                        .padding(.leading, 10)
                } else {
                    Image("ic-user")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .cornerRadius(17.5)
                        .padding(.leading, 10)
                }

                VStack(alignment: .leading, content: {
                    Text(title)
                        .font(FontUtility.smallText3())
                        .foregroundColor(Color.castType)
                        .multilineTextAlignment(.leading)

                    Text(name)
                        .font(FontUtility.smallText1())
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.leading)
                })
                .padding(.top, 15)
                .padding(.bottom, 15)
                .padding(.trailing, 15)
            })
        })
        .background(Color.castBg)
        .cornerRadius(15)
    }
}


#if DEBUG
@available(iOS 14.0, *)
struct CastView_Previews: PreviewProvider {
    static var previews: some View {
        CastView()
    }
}
#endif
