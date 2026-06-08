//
//  QuickAPITestViewController.swift
//  HeyPlay
//
//  Quick testing screen for new API implementations
//  Add this to your project for easy testing
//

import UIKit
import Combine

class QuickAPITestViewController: UIViewController {

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "API Test Screen"

        setupUI()
    }

    func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Test Buttons
        stackView.addArrangedSubview(createSectionLabel("Video Player"))
        stackView.addArrangedSubview(createTestButton("Test Video Player", action: #selector(testVideoPlayer)))

        stackView.addArrangedSubview(createSectionLabel("Notifications"))
        stackView.addArrangedSubview(createTestButton("Test Notifications", action: #selector(testNotifications)))

        stackView.addArrangedSubview(createSectionLabel("Login"))
        stackView.addArrangedSubview(createTestButton("Test Phone Login", action: #selector(testLogin)))

        stackView.addArrangedSubview(createSectionLabel("Watch List"))
        stackView.addArrangedSubview(createTestButton("Test Watch Later", action: #selector(testWatchLater)))
        stackView.addArrangedSubview(createTestButton("Test Last Watch", action: #selector(testLastWatch)))
        stackView.addArrangedSubview(createTestButton("Test Favourites", action: #selector(testFavourites)))

        stackView.addArrangedSubview(createSectionLabel("Movie Detail"))
        stackView.addArrangedSubview(createTestButton("Test Toggle Favourite", action: #selector(testToggleFavourite)))
        stackView.addArrangedSubview(createTestButton("Test Toggle Watch Later", action: #selector(testToggleWatchLater)))

        stackView.addArrangedSubview(createSectionLabel("Reels"))
        stackView.addArrangedSubview(createTestButton("Test Reel Favourite", action: #selector(testReelFavourite)))
    }

    func createSectionLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }

    func createTestButton(_ title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    // MARK: - Test Methods

    @objc func testVideoPlayer() {
        print("\n🎬 Testing Video Player...")
        let viewModel = VideoPlayerViewModel(movieId: 959, episodeId: nil)

        viewModel.$streamingUrl
            .compactMap { $0 }
            .sink { url in
                print("✅ Streaming URL: \(url)")
                self.showAlert("Success", "Got streaming URL: \(url.prefix(50))...")
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap { $0 }
            .sink { error in
                print("❌ Error: \(error)")
                self.showAlert("Error", error)
            }
            .store(in: &cancellables)

        viewModel.fetchStreamingUrl()
    }

    @objc func testNotifications() {
        print("\n📬 Testing Notifications...")
        let viewModel = NotificationViewModel()

        viewModel.$notifications
            .sink { notifications in
                print("✅ Received \(notifications.count) notifications")
                print("Unread count: \(viewModel.unreadCount)")
                self.showAlert("Success", "Loaded \(notifications.count) notifications\nUnread: \(viewModel.unreadCount)")
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap { $0 }
            .sink { error in
                print("❌ Error: \(error)")
                self.showAlert("Error", error)
            }
            .store(in: &cancellables)

        viewModel.fetchNotifications()
    }

    @objc func testLogin() {
        print("\n🔐 Testing Login...")

        let alert = UIAlertController(title: "Login Test", message: "This will test phone validation", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "09XXXXXXXXX"
            textField.text = "09682309272"
            textField.keyboardType = .phonePad
        }
        alert.addAction(UIAlertAction(title: "Test", style: .default) { _ in
            let phone = alert.textFields?[0].text ?? ""
            let viewModel = LoginViewModel()
            viewModel.phoneNumber = phone

            viewModel.$showOTPScreen
                .sink { show in
                    if show {
                        print("✅ OTP screen should show")
                        self.showAlert("Success", "Phone validated! OTP sent.")
                    }
                }
                .store(in: &self.cancellables)

            viewModel.$errorMessage
                .compactMap { $0 }
                .sink { error in
                    print("❌ Error: \(error)")
                    self.showAlert("Error", error)
                }
                .store(in: &self.cancellables)

            viewModel.validatePhoneNumber()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @objc func testWatchLater() {
        print("\n📋 Testing Watch Later...")
        let viewModel = WatchListViewModel(listType: .watchLater)

        viewModel.$watchLaterItems
            .sink { items in
                print("✅ Watch Later: \(items.count) items")
                self.showAlert("Watch Later", "\(items.count) items in watch later list")
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap { $0 }
            .sink { error in
                print("❌ Error: \(error)")
                self.showAlert("Error", error)
            }
            .store(in: &cancellables)

        viewModel.fetchData()
    }

    @objc func testLastWatch() {
        print("\n📺 Testing Last Watch...")
        let viewModel = WatchListViewModel(listType: .lastWatch)

        viewModel.$lastWatchItems
            .sink { items in
                print("✅ Last Watch: \(items.count) items")
                self.showAlert("Last Watch", "\(items.count) items in watch history")
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap { $0 }
            .sink { error in
                print("❌ Error: \(error)")
                self.showAlert("Error", error)
            }
            .store(in: &cancellables)

        viewModel.fetchData()
    }

    @objc func testFavourites() {
        print("\n❤️ Testing Favourites...")
        let viewModel = WatchListViewModel(listType: .favourites)

        viewModel.$favouriteItems
            .sink { items in
                print("✅ Favourites: \(items.count) items")
                self.showAlert("Favourites", "\(items.count) favourite items")
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap { $0 }
            .sink { error in
                print("❌ Error: \(error)")
                self.showAlert("Error", error)
            }
            .store(in: &cancellables)

        viewModel.fetchData()
    }

    @objc func testToggleFavourite() {
        print("\n❤️ Testing Toggle Favourite...")
        let viewModel = MovieDetailViewModel(movieId: 959)

        // First fetch detail
        viewModel.fetchContentDetail()

        viewModel.$contentDetail
            .compactMap { $0 }
            .sink { detail in
                print("Current favourite status: \(detail.isFavourite)")

                // Now toggle
                viewModel.toggleFavourite()

                // Wait and check again
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    print("New favourite status: \(viewModel.contentDetail?.isFavourite ?? false)")
                    self.showAlert("Success", "Favourite toggled!")
                }
            }
            .store(in: &cancellables)
    }

    @objc func testToggleWatchLater() {
        print("\n📌 Testing Toggle Watch Later...")
        let viewModel = MovieDetailViewModel(movieId: 959)

        viewModel.fetchContentDetail()

        viewModel.$contentDetail
            .compactMap { $0 }
            .sink { detail in
                print("Current watch later status: \(detail.isInWatchLater)")

                viewModel.toggleWatchList()

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    print("New watch later status: \(viewModel.contentDetail?.isInWatchLater ?? false)")
                    self.showAlert("Success", "Watch later toggled!")
                }
            }
            .store(in: &cancellables)
    }

    @objc func testReelFavourite() {
        print("\n❤️ Testing Reel Favourite...")
        let viewModel = HotViewModel()

        viewModel.$reels
            .sink { reels in
                if !reels.isEmpty {
                    print("Testing with first reel: \(reels[0].id)")
                    viewModel.toggleFavorite(at: 0)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.showAlert("Success", "Reel favourite toggled!")
                    }
                } else {
                    print("No reels to test")
                    self.showAlert("Info", "No reels available. Fetching...")
                }
            }
            .store(in: &cancellables)

        viewModel.fetchReels()
    }

    // MARK: - Helper
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - How to use this test screen
/*
 1. Add this file to your Xcode project
 2. In any view controller, add a test button:

 let testButton = UIButton()
 testButton.setTitle("API Tests", for: .normal)
 testButton.addTarget(self, action: #selector(showAPITests), for: .touchUpInside)

 @objc func showAPITests() {
     let testVC = QuickAPITestViewController()
     navigationController?.pushViewController(testVC, animated: true)
 }

 3. Tap the button to see test screen with all test buttons
 4. Tap any test button to test that feature
 5. Watch console for detailed logs
 6. Shake device to see Wormholy network inspector
 */
