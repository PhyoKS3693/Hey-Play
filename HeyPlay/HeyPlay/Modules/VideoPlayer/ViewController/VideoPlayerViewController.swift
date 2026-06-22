//
//  VideoPlayerViewController.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 12/17/25.
//

import Foundation
import UIKit
import SwiftUI

final class VideoPlayerViewController: BaseViewController {

    let viewModel = VideoPlayerViewModel()
    var streamingUrl: String = ""
    var videoTitle: String = ""
    var movieId: Int = 0
    var episodeId: String? = nil

    deinit {
        print("♻️ [VideoPlayerViewController] Deinit called - final cleanup")

        // Restore orientation (don't call saveWatchProgress here as it could retain self)
        AppDelegate.orientationLock = .all
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "black_Color")

        // Set streaming URL and title in view model
        if !streamingUrl.isEmpty {
            viewModel.streamingUrl = streamingUrl
        }
        viewModel.videoTitle = videoTitle
        viewModel.setMovieInfo(movieId: movieId, episodeId: episodeId)

        print("🎬 [VideoPlayerViewController] Loading player with URL: \(streamingUrl)")
        print("🎬 [VideoPlayerViewController] Title: \(videoTitle)")
        print("🎬 [VideoPlayerViewController] MovieId: \(movieId), EpisodeId: \(episodeId ?? "nil")")

        let videoPlayerView = VideoPlayerView(viewModel)
        let controller = UIHostingController(rootView: videoPlayerView)
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        controller.view.backgroundColor = .black

        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Lock to landscape orientation
        AppDelegate.orientationLock = .landscape

        // Force rotate to landscape
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print("💾 [VideoPlayerViewController] View disappearing, saving progress and cleaning up...")

        // Save watch progress before leaving
        viewModel.saveWatchProgress()

        // Restore portrait orientation
        AppDelegate.orientationLock = .portrait

        // Force rotation to portrait on main thread
        DispatchQueue.main.async {
            if #available(iOS 16.0, *) {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
            } else {
                let value = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
            }

            // Unlock all orientations after rotation completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                AppDelegate.orientationLock = .all
                print("✅ [VideoPlayerViewController] Portrait restored, all orientations unlocked")
            }
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
}
