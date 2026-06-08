//
//  MovieCollectionTableViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 05/11/2025.
//

import UIKit

class MovieCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var lblCollectionName: UILabel!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    var navigateToDetail: ((Int) -> Void)?
    var navigateToViewAll: (() -> Void)?

    // Movie data
    var movies: [Movie] = [] {
        didSet {
            collectionView.reloadData()
            updateCollectionViewHeight()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        bgView.backgroundColor = .darkGrey
        bgView.cornerRadius = 15
        bgView.clipsToBounds = true

        // Fix label truncation - allow multiple lines and prevent truncation
        lblCollectionName.numberOfLines = 2
        lblCollectionName.lineBreakMode = .byWordWrapping
        lblCollectionName.setContentCompressionResistancePriority(.required, for: .horizontal)
        lblCollectionName.setContentHuggingPriority(.defaultLow, for: .horizontal)

        setupCollection()
    }

    func setupCollection() {
        collectionView.registerForCell(strID: FullMovieCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }

    private func updateCollectionViewHeight() {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let itemHeight: CGFloat = 206
        let spacing = flowLayout.minimumLineSpacing

        // Calculate rows: Since we show 2.5 items width, calculate ceil(count / 2.5)
        let itemsPerRow: CGFloat = 2.5
        let rowCount = max(1, Int(ceil(CGFloat(movies.count) / itemsPerRow)))
        let totalHeight = CGFloat(rowCount) * itemHeight + CGFloat(max(0, rowCount - 1)) * spacing

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            // Try to find height constraint if outlet is not connected
            if self.collectionViewHeightConstraint == nil {
                for constraint in self.collectionView.constraints {
                    if constraint.firstAttribute == .height {
                        constraint.constant = totalHeight
                        return
                    }
                }
            } else {
                self.collectionViewHeightConstraint?.constant = totalHeight
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func onClickViewAll(_ sender: Any) {
        navigateToViewAll?()
    }

    // MARK: - Configure with Data
    func configure(title: String, movies: [Movie]) {
        lblCollectionName.text = title
        self.movies = movies
    }
}

extension MovieCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Only show actual movies, no placeholders
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullMovieCollectionViewCell.identifier, for: indexPath) as? FullMovieCollectionViewCell else {
            return UICollectionViewCell()
        }

        if !movies.isEmpty && indexPath.item < movies.count {
            cell.configure(with: movies[indexPath.item])
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 50) / 2.5, height: 206)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !movies.isEmpty && indexPath.item < movies.count {
            navigateToDetail?(movies[indexPath.item].id)
        } else {
            navigateToDetail?(indexPath.item)
        }
    }
}
