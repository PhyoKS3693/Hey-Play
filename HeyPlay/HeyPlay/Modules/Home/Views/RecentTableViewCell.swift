//
//  RecentTableViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit

class RecentTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnSeeAll: UIButton!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    var navigateToMovieDetail: ((Int) -> Void)?
    var navigateToViewAll: (() -> Void)?
    var onDeleteMovie: ((Int) -> Void)?

    // Movie data
    var movies: [Movie] = [] {
        didSet {
            collectionView.reloadData()
            updateCollectionViewHeight()
        }
    }

    // Control delete button visibility
    var showDeleteButton: Bool = false {
        didSet {
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.selectionStyle = .none

        lblTitle.text = "Recent"

        bgView.backgroundColor = .darkGrey
        bgView.cornerRadius = 15
        bgView.clipsToBounds = true

        // Fix label truncation - allow multiple lines and prevent truncation
        lblTitle.numberOfLines = 2
        lblTitle.lineBreakMode = .byWordWrapping
        lblTitle.setContentCompressionResistancePriority(.required, for: .horizontal)
        lblTitle.setContentHuggingPriority(.defaultLow, for: .horizontal)

        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerForCell(strID: RecentCollectionViewCell.identifier)
        collectionView.reloadData()
    }

    private func updateCollectionViewHeight() {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let itemHeight: CGFloat = 136
        let spacing = flowLayout.minimumLineSpacing

        // Calculate rows: 2 items per row
        let itemsPerRow: CGFloat = 2
        let rowCount = max(1, Int(ceil(CGFloat(movies.count) / itemsPerRow)))
        let totalHeight = CGFloat(rowCount) * itemHeight + CGFloat(max(0, rowCount - 1)) * spacing

        DispatchQueue.main.async { [weak self] in
            self?.collectionViewHeightConstraint?.constant = totalHeight
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func onClickSeeAll(_ sender: Any) {
        navigateToViewAll?()
    }

    // MARK: - Configure with Data
    func configure(title: String, movies: [Movie]) {
        lblTitle.text = title
        self.movies = movies
    }
}

extension RecentTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Only show actual movies, no placeholders
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentCollectionViewCell.identifier, for: indexPath) as? RecentCollectionViewCell else {
            return UICollectionViewCell()
        }

        if !movies.isEmpty && indexPath.item < movies.count {
            let movie = movies[indexPath.item]
            cell.configure(with: movie, showDeleteButton: showDeleteButton)

            // Set delete callback
            cell.onDeleteTapped = { [weak self] in
                self?.onDeleteMovie?(movie.id)
            }
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 50) / 2, height: 136)
    }
}
