//
//  MovieTableViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    var navigateToMovieDetail: ((Int) -> Void)?
    var navigateToViewAll: (() -> Void)?

    // Movie data
    var movies: [Movie] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    var sectionTitle: String? {
        didSet {
            lblName.text = sectionTitle
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none

        bgView.backgroundColor = .darkGrey

        setupCollectionView()

        // Set fixed height for collection view
        setCollectionViewHeight()
    }

    func setupCollectionView() {
        // Initialize the custom layout.
        let layout = HorizontalTwoRowLayout()
        layout.collectionView?.backgroundColor = .clear
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        // Initialize the collection view with the custom layout.
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.autoresizingMask = [.flexibleWidth]
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerForCell(strID: FullMovieCollectionViewCell.identifier)
        collectionView.reloadData()
    }

    private func setCollectionViewHeight() {
        // Set a fixed height constraint for the collection view
        // First, check if there's already a height constraint from XIB
        var hasHeightConstraint = false

        for constraint in collectionView.constraints {
            if constraint.firstAttribute == .height {
                // Update existing height constraint
                constraint.constant = 240
                hasHeightConstraint = true
                break
            }
        }

        // If no height constraint exists, add one
        if !hasHeightConstraint {
            let heightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 240)
            heightConstraint.priority = .required
            heightConstraint.isActive = true
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
        self.sectionTitle = title
        self.movies = movies
    }
}

extension MovieTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.isEmpty ? 5 : movies.count
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !movies.isEmpty && indexPath.item < movies.count {
            navigateToMovieDetail?(movies[indexPath.item].id)
        } else {
            navigateToMovieDetail?(indexPath.item)
        }
    }
}
