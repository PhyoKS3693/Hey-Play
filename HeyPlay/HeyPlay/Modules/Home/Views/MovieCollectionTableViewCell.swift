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
        setFixedCollectionViewHeight()
    }

    func setupCollection() {
        collectionView.registerForCell(strID: FullMovieCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self

        // Create a new flow layout to ensure clean state
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.estimatedItemSize = .zero // Disable automatic sizing - use exact sizes from delegate
        flowLayout.minimumLineSpacing = Self.itemSpacing
        flowLayout.minimumInteritemSpacing = Self.itemSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: Self.itemSpacing, bottom: 0, right: Self.itemSpacing)

        collectionView.collectionViewLayout = flowLayout
        collectionView.reloadData()
    }

    // MARK: - Constants for Layout 6
    private static let itemHeight: CGFloat = 200 // Fixed constant height for each item
    private static let itemSpacing: CGFloat = 10
    private static let numberOfRows: CGFloat = 2

    private func setFixedCollectionViewHeight() {
        // Set a constant height for Layout 6 (2 rows of items)
        let fixedHeight = (Self.itemHeight * Self.numberOfRows) + (Self.itemSpacing * (Self.numberOfRows - 1))

        // Try to find height constraint if outlet is not connected
        if collectionViewHeightConstraint == nil {
            for constraint in collectionView.constraints {
                if constraint.firstAttribute == .height {
                    constraint.constant = fixedHeight
                    return
                }
            }
            // If no constraint found, create one
            let heightConstraint = collectionView.heightAnchor.constraint(equalToConstant: fixedHeight)
            heightConstraint.isActive = true
        } else {
            collectionViewHeightConstraint?.constant = fixedHeight
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
        // Layout 6: 2 columns grid with equal padding and CONSTANT item height
        let totalSpacing = Self.itemSpacing * 3 // left + middle + right

        // Use the container width if collection view width is not available yet
        let containerWidth = collectionView.bounds.width > 0 ? collectionView.bounds.width : self.bounds.width
        let availableWidth = containerWidth - totalSpacing
        let itemWidth = max(0, availableWidth / 2) // Prevent negative width

        // Use the constant item height
        return CGSize(width: itemWidth, height: Self.itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Self.itemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Self.itemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: Self.itemSpacing, bottom: 0, right: Self.itemSpacing)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !movies.isEmpty && indexPath.item < movies.count {
            navigateToDetail?(movies[indexPath.item].id)
        } else {
            navigateToDetail?(indexPath.item)
        }
    }
}
