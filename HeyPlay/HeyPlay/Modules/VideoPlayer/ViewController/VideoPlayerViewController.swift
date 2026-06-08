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

        // Save watch progress before leaving
        print("💾 [VideoPlayerViewController] View disappearing, saving progress...")
        viewModel.saveWatchProgress()
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        print("🔄 [VideoPlayerViewController] Dismissing, restoring portrait orientation")

        // First unlock orientation
        AppDelegate.orientationLock = .portrait

        // Force rotation to portrait
        if #available(iOS 16.0, *) {
            // iOS 16+ method
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        } else {
            // iOS 15 and below
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }

        // Call super dismiss with completion that unlocks orientation
        super.dismiss(animated: flag) {
            print("✅ [VideoPlayerViewController] Dismissed, portrait restored")
            // After dismiss completes, allow all orientations again
            AppDelegate.orientationLock = .all
            completion?()
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
