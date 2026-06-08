//
//  CollectionResultViewController.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 12/16/25.
//

import UIKit
import Combine

class CollectionResultViewController: BaseViewController {

    @IBOutlet weak var cvResult: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!

    // ViewModel
    private var viewModel: CollectionResultViewModel!

    // Playlist properties (set before presenting)
    var playlistId: String = ""
    var playlistTitle: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        // Hide the close/back button
        btnClose?.isHidden = true

        // Hide navigation bar back button if pushed
        navigationItem.hidesBackButton = true

        setupViewModel()
        setupCollectionView()
        bindViewModel()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Setup
    private func setupViewModel() {
        viewModel = CollectionResultViewModel(
            playlistId: playlistId,
            playlistTitle: playlistTitle
        )
    }

    private func setupCollectionView() {
        cvResult.registerForCell(strID: FullMovieCollectionViewCell.identifier)
        cvResult.delegate = self
        cvResult.dataSource = self

        // Setup collection view layout
        if let layout = cvResult.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 16
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        // Bind playlist title
        viewModel.$playlistTitle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.lblTitle?.text = title
            }
            .store(in: &cancellables)

        // Bind total count text
        viewModel.$totalCountText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.lblSubtitle?.text = text
            }
            .store(in: &cancellables)

        // Bind movies
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.cvResult.reloadData()
            }
            .store(in: &cancellables)

        // Bind error
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let error = errorMessage {
                    self?.showError(error)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Load Data
    private func loadData() {
        Task {
            await viewModel.fetchPlaylistDetail()
        }
    }

    // MARK: - Error Handling
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Actions
    @IBAction func onTapClose(_ sender: Any) {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension CollectionResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Show placeholder cells when loading, otherwise show actual data
        return viewModel.movies.isEmpty && viewModel.isLoading ? 9 : viewModel.movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FullMovieCollectionViewCell.identifier,
            for: indexPath
        ) as? FullMovieCollectionViewCell else {
            return UICollectionViewCell()
        }

        // Configure cell with movie data if available
        if !viewModel.movies.isEmpty && indexPath.item < viewModel.movies.count {
            cell.configure(with: viewModel.movies[indexPath.item])
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate cell size for 3 columns with spacing
        let spacing: CGFloat = 8
        let insets: CGFloat = 16 * 2 // left + right
        let totalSpacing = (spacing * 2) + insets // 2 spaces between 3 items
        let width = (collectionView.bounds.width - totalSpacing) / 3

        // Maintain aspect ratio similar to reference image (approximately 2:3)
        let height = width * 1.7

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !viewModel.movies.isEmpty && indexPath.item < viewModel.movies.count else { return }

        let movie = viewModel.movies[indexPath.item]
        let detailType: DetailType = movie.isSeries ? .series : .movie
        ViewNavigation.shared.showMovieDetail(detailType: detailType, movieId: movie.id)
    }

    // MARK: - Pagination (Load More)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        // Trigger load more when scrolled near bottom
        if offsetY > contentHeight - frameHeight - 100 {
            if viewModel.canLoadMore {
                Task {
                    await viewModel.loadMore()
                }
            }
        }
    }
}
