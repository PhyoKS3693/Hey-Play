//
//  MovieViewController + Extension.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 10/08/2025.
//

import Foundation
import UIKit

extension MovieAndSeariesViewController {
    func setupCollectionView () {
        collectionView.registerForCell(strID: FullMovieCollectionViewCell.identifier)
        collectionView.registerForCell(strID: SeriesTypeCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.reloadData()
    }
}

extension MovieAndSeariesViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getMovieCell(with: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Load more when reaching the last few items
        let totalItems = viewModel.searchResults.count
        if indexPath.item >= totalItems - 5 && viewModel.canLoadMore {
            Task {
                await viewModel.loadMoreBrowse()
            }
        }
    }

    func getMovieCell(with indexPath : IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullMovieCollectionViewCell.identifier, for: indexPath) as? FullMovieCollectionViewCell else {
            return UICollectionViewCell()
        }

        // Configure cell with actual movie data
        let movie = viewModel.searchResults[indexPath.item]
        cell.configure(with: movie)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < viewModel.searchResults.count else { return }
        let movie = viewModel.searchResults[indexPath.item]
        let detailType: DetailType = movie.isSeries ? .series : .movie
        ViewNavigation.shared.showMovieDetail(detailType: detailType, movieId: movie.id)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: (collectionView.frame.width - 20) / 3, height: 180)
    }
}
