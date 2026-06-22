//
//  VideoPlayerView.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 12/17/25.
//

import SwiftUI

struct VideoPlayerView: View {
    var host: HostController?

    var didTapBack: (() -> Void)?

    @State private var sliderValue: Double = .zero
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject private var viewModel: VideoPlayerViewModel

    init(_ viewModel: VideoPlayerViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    // Add onDisappear to cleanup
    private func cleanup() {
        print("🧹 [VideoPlayerView] Cleaning up")
        viewModel.saveWatchProgress()
    }
    
    var body: some View {
        ZStack {
            // Video player fullscreen
            if viewModel.hasStreamingUrl {
                videoView(viewModel.streamingUrl ?? "")
            } else {
                VStack {
                    Text("No video URL available")
                        .foregroundColor(.white)
                        .padding()

                    Text("URL: \(viewModel.streamingUrl ?? "empty")")
                        .foregroundColor(.gray)
                        .font(.caption)
                        .padding()
                }
            }

            // Navigation overlay at the top
            VStack {
                navView(viewModel.videoTitle)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                Spacer()
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onDisappear {
            cleanup()
        }
    }
    
    private func navView(_ title: String) -> some View {
        ZStack (alignment: .leading){
            Button{
                print("🔙 [VideoPlayerView] Back button tapped")

                // Save watch progress
                viewModel.saveWatchProgress()

                // Restore portrait orientation
                AppDelegate.orientationLock = .portrait

                // Dismiss immediately - let the view controller handle orientation
                presentationMode.wrappedValue.dismiss()

                didTapBack?()
            } label: {
                Image("ic.backBtn")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }

            HStack {
                Spacer()

                Text(title.isEmpty ? "Video Player" : title)
                    .font(FontUtility.subHeadline())
                    .foregroundColor(Color("white_color"))
                    .lineLimit(1)

                Spacer()
            }
        }
        .padding(10)
    }
    
    private func videoView(_ url: String) -> some View {
        PlayerView(videoURL: url, viewModel: viewModel)
            .edgesIgnoringSafeArea(.all)
    }
}
