//
//  SeriesTableViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 08/08/2025.
//

import UIKit

class SeriesTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!

    var navigateToSeriesDetail: ((Int) -> Void)?
    var navigateToViewAll: (() -> Void)?

    // Movie/Series data
    var movies: [Movie] = [] {
        didSet {
            collectionView.reloadData()
            updateCollectionViewHeight()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none

        // Fix label truncation - allow multiple lines and prevent truncation
        lblName.numberOfLines = 2
        lblName.lineBreakMode = .byWordWrapping
        lblName.setContentCompressionResistancePriority(.required, for: .horizontal)
        lblName.setContentHuggingPriority(.defaultLow, for: .horizontal)

        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.registerForCell(strID: SeriesCollectionViewCell.identifier)
        updateCollectionViewHeight()
        collectionView.reloadData()
    }

    private func updateCollectionViewHeight() {
        let itemCount = movies.count
        DispatchQueue.main.async {
            self.collectionViewHeight.constant = CGFloat(90 * itemCount)
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
        lblName.text = title
        self.movies = movies
    }
}

extension SeriesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Only show actual movies, no placeholders
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeriesCollectionViewCell.identifier, for: indexPath) as? SeriesCollectionViewCell else {
            return UICollectionViewCell()
        }

        if !movies.isEmpty && indexPath.item < movies.count {
            cell.configure(with: movies[indexPath.item])
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 90)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !movies.isEmpty && indexPath.item < movies.count {
            navigateToSeriesDetail?(movies[indexPath.item].id)
        } else {
            navigateToSeriesDetail?(indexPath.item)
        }
    }
}
