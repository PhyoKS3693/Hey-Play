//
//  MovieViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 10/08/2025.
//

import UIKit
import Combine

class MovieAndSeariesViewController: BaseViewController {
    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var collectionView : UICollectionView!

    // ViewModel for search/browse
    let viewModel = SearchViewModel()

    // Configuration from parent
    var movieType: String = "1" // "1" for Movie, "2" for Series
    var movieOrigin: String = "" // "1" for Local, "2" for International, "" for All

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindViewModel()
        loadContent()
    }

    private func bindViewModel() {
        // Observe searchResults changes
        viewModel.$searchResults
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        // Observe loading state
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                // You can show/hide loading indicator here if needed
                print("Loading: \(isLoading)")
            }
            .store(in: &cancellables)
    }

    private func loadContent() {
        Task {
            await viewModel.browseContent(movieType: movieType, movieOrigin: movieOrigin)
        }
    }
}
