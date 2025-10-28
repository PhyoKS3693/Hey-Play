//
//  WatchListScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct WatchListScreen: View {
    var host: HostController?
    
    var didTapClearAll: (() -> Void)?
    
    @ObservedObject private var viewModel: WatchListViewModel
    
    @State private var isShowRecent: Bool = true
    
    init(_ viewModel: WatchListViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    self.isShowRecent = true
                } label: {
                    Text("Recent")
                        .font(FontUtility.regularFont(size: 13))
                        .foregroundColor(Color("white_color"))
                        .padding(6)
                }
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isShowRecent ? Color("pink_Color") : Color("darkGrey_Color"))
                )
                
                
                Button {
                    self.isShowRecent = false
                } label: {
                    Text("Watchlist")
                        .font(FontUtility.regularFont(size: 13))
                        .foregroundColor(Color("white_color"))
                        .padding(6)
                }
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isShowRecent ? Color("darkGrey_Color") : Color("pink_Color"))
                )
                
                Spacer()
                
                Button {
                    self.didTapClearAll?()
                } label: {
                    Text("Clear All")
                        .font(FontUtility.regularFont(size: 12))
                        .foregroundColor(Color("red_Color"))
                        .padding(.horizontal, 8)
                }
            }
            
            ScrollView {
                if isShowRecent {
                    renderRecent("recent", "ဒုဋ္ဌဝတီကိုလွန်၍", "July 07, 2025")
                    
                    renderRecent("recent_1", "အကယ်ဒမီရှော့", "July 07, 2025")
                    
                    renderRecent("recent_2", "ရန်သူ‌တော် သမက်‌‌လောင်း", "July 07, 2025")
                } else {
                    renderWatchList("series", "အမုန်းမြစ် (Season 1)", "July 07, 2025", false)
                    
                    renderWatchList("series_1", "နင့်် (Season 1)", "July 07, 2025", true)
                    
                    renderWatchList("series_1", "ကြောက်သလား မမေးနဲ့", "July 07, 2025", false)
                }
            }
        }
    }
    
    private func renderRecent(_ videoUrl: String,_ videoTitle: String,_ lastWatchTime: String ) -> some View {
        HStack {
            ZStack {
                Image(videoUrl)
                    .frame(width: 120, height: 67)
                    .background(
                        RoundedRectangle(cornerRadius: 8))
                
                Image("ic-play")
                    .frame(width: 20, height: 20)
            }
            .padding(.leading, 10)
            .padding(.vertical, 6)
            
            VStack(alignment: .leading) {
                Text(videoTitle)
                    .font(FontUtility.regularFont(size: 12))
                    .foregroundColor(Color("white_color"))
                    .padding(.vertical, 4)
                
                HStack {
                    Image("ic_clock")
                        .frame(width: 15, height: 15)
                        .padding(.trailing, 4)
                    
                    Text("Last watch on:")
                        .font(FontUtility.regularFont(size: 10))
                        .foregroundColor(Color("white_color"))
                    
                    Text(lastWatchTime)
                        .font(FontUtility.regularFont(size: 10))
                        .foregroundColor(Color("white_color"))
                    
                    Spacer()
                    
                    Image("ic-delete")
                        .frame(width: 20, height: 20)
                        .padding(.horizontal, 8)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("darkGrey_Color"))
        )
        .frame(maxWidth: .infinity)
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
    }
    
    private func renderWatchList(_ videoUrl: String,_ videoTitle: String,_ lastWatchTime: String,_ isFree: Bool) -> some View {
        HStack {
            ZStack(alignment: .bottomLeading) {
                Image(videoUrl)
                    .frame(width: 120, height: 67)
                    .background(
                        RoundedRectangle(cornerRadius: 8))
                
                Image(isFree ? "free_badge" : "vip_badge")
                    .frame(width: 40, height: 22)
                    .padding(.leading, 4)
                    .padding(.bottom, 6)
            }
            .padding(.leading, 10)
            .padding(.vertical, 6)
            
            VStack(alignment: .leading) {
                Text(videoTitle)
                    .font(FontUtility.regularFont(size: 12))
                    .foregroundColor(Color("white_color"))
                    .padding(.vertical, 4)
                
                HStack {
                    Image("ic_clock")
                        .frame(width: 15, height: 15)
                        .padding(.trailing, 4)
                    
                    Text("Watchlist on:")
                        .font(FontUtility.regularFont(size: 10))
                        .foregroundColor(Color("white_color"))
                    
                    Text(lastWatchTime)
                        .font(FontUtility.regularFont(size: 10))
                        .foregroundColor(Color("white_color"))
                    
                    Spacer()
                    
                    Image("ic-delete")
                        .frame(width: 20, height: 20)
                        .padding(.horizontal, 8)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("darkGrey_Color"))
        )
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
    }
}

#Preview {
    WatchListScreen(.init())
}
