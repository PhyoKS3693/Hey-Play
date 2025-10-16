//
//  ViewPagerViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 10/08/2025.
//

import UIKit

class ViewPagerViewController: BaseViewController {

    private let tabTitles = ["Local", "International"]
    var selectedIndex = 0

    private let localVC = MovieAndSeariesViewController()
    private let internationalVC = MovieAndSeariesViewController()
    lazy var viewControllers: [UIViewController] = [localVC, internationalVC]

    var movieSeriesType : MovieSeriesType = .movie
    private let tabStackView = UIStackView()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    private var buttons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
    }
    
    override func setupUI() {
        super.setupUI()
        if movieSeriesType == .series {
            setupTabs()
        }
        setBottomTabBar()
        setupCollectionView()
        setNavTitle()
        setRightBarItems()
    }
    
    func setBottomTabBar() {
        setupBottomBar()
        setTabBarItem()
    }

    private func setupTabs() {
        tabStackView.axis = .horizontal
        tabStackView.spacing = 16
        tabStackView.distribution = .fillProportionally
        tabStackView.translatesAutoresizingMaskIntoConstraints = false

        for (index, title) in tabTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.tag = index
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = index == 0 ? .systemPink : .darkGray
            button.layer.cornerRadius = 22
            button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            tabStackView.addArrangedSubview(button)
        }

        view.addSubview(tabStackView)

        NSLayoutConstraint.activate([
            tabStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            tabStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -150),
            tabStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func tabTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
        updateTabUI()
        scrollToPage(index: selectedIndex)
    }

    func updateTabUI() {
        for (index, button) in buttons.enumerated() {
            button.backgroundColor = index == selectedIndex ? .systemPink : .darkGray
        }
    }

    private func scrollToPage(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerForCell(strID: PageContainerCollectionViewCell.identifier)

        view.addSubview(collectionView)
        
        if movieSeriesType == .series {
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: tabStackView.bottomAnchor, constant: 20),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
            ])
        }
        else {
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
            ])
        }
       
    }
}
