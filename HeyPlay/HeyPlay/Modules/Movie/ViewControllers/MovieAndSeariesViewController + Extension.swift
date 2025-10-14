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
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            return getMovieCell(with: indexPath)
    }
  
    
    func getMovieCell(with indexPath : IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullMovieCollectionViewCell.identifier, for: indexPath) as? FullMovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: (collectionView.frame.width - 20) / 3, height: 180)
    }
}
