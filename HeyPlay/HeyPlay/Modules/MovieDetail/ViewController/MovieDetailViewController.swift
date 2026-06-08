//
//  MovieDetailViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 16/10/2025.
//

import UIKit
import SwiftUI

enum DetailType {
    case movie
    case series
}

class MovieDetailViewController: BaseViewController {

    var detailType: DetailType = .movie
    var movieId: Int = 0

    // ViewModel - initialized as optional, created in viewDidLoad
    private var viewModel: MovieDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        // Initialize viewModel with the correct movieId and detailType
        viewModel = MovieDetailViewModel(movieId: movieId, detailType: detailType)

        setupSwiftUIView()

        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }

    private func setupSwiftUIView() {
        if #available(iOS 14.0, *) {
            let detailView = MovieDetailView(
                viewModel: viewModel,
                detailType: detailType
            )
            let hostingController = UIHostingController(rootView: detailView)

            addChild(hostingController)
            view.addSubview(hostingController.view)
            hostingController.didMove(toParent: self)

            // Set constraints
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            hostingController.view.snp.makeConstraints { make in
                make.leading.trailing.top.bottom.equalToSuperview().inset(0)
            }
        } else {
            // Fallback for iOS 13
            let label = UILabel()
            label.text = "Please update to iOS 14 or later"
            label.textColor = .white
            label.textAlignment = .center
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
}
