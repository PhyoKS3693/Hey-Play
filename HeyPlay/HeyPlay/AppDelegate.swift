//
//  AppDelegate.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseMessaging
import LineSDK
import UserNotifications
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // Orientation lock property
    static var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window = self.window {
            let controller = HomeViewController()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyBoard.instantiateViewController(identifier: String(describing: SplashViewController.self)) as? SplashViewController else {return false}
            let navVC = UINavigationController(rootViewController: controller)
            navVC.navigationBar.isHidden = false
            window.rootViewController = navVC
            window.makeKeyAndVisible()

            //            let initialViewController = HomeViewController()
            //            let nav = UINavigationController(rootViewController: initialViewController)
            //            self.window?.rootViewController = nav
            //            self.window?.makeKeyAndVisible()

        }

        print("🔥 [Firebase] Configuring Firebase...")
        // Configure Firebase
        FirebaseApp.configure()
        print("🔥 [Firebase] Firebase configured successfully")

        // Setup LINE SDK
        LoginManager.shared.setup(channelID: "2000867689", universalLinkURL: nil)

        // Setup Push Notifications
        setupPushNotifications(application)

        // Initialize Google Mobile Ads SDK
        MobileAds.shared.start { status in
            print("✅ [AdMob] SDK initialized")
        }

        return true
    }

    // MARK: - Push Notification Setup
    private func setupPushNotifications(_ application: UIApplication) {
        print("📱 [Notification] Setting up push notifications...")

        // Set Firebase Messaging delegate
        Messaging.messaging().delegate = self
        print("📱 [Notification] Firebase Messaging delegate set")

        // Set UNUserNotificationCenter delegate
        UNUserNotificationCenter.current().delegate = self
        print("📱 [Notification] UNUserNotificationCenter delegate set")

        // Request notification permissions
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                if let error = error {
                    print("❌ [Notification] Error requesting authorization: \(error.localizedDescription)")
                    return
                }

                if granted {
                    print("✅ [Notification] Permission granted")
                    DispatchQueue.main.async {
                        print("📱 [Notification] Registering for remote notifications...")
                        application.registerForRemoteNotifications()
                    }
                } else {
                    print("⚠️ [Notification] Permission denied by user")
                }
            }
        )

        // Get current FCM token if available
        Messaging.messaging().token { token, error in
            if let error = error {
                print("❌ [FCM] Error fetching token: \(error.localizedDescription)")
            } else if let token = token {
                print("🔥 [FCM] Token fetched immediately: \(token)")
            } else {
                print("⚠️ [FCM] No token available yet, waiting for delegate callback")
            }
        }
    }

    // MARK: - Remote Notification Registration
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("✅ ============================================")
        print("✅ [APNS] Successfully registered for remote notifications")
        print("✅ ============================================")

        // Convert device token to string
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("📱 [APNS] Device Token: \(token)")
        print("📱 [APNS] Token Length: \(token.count) characters")

        // Store device token
        UserDefaults.standard.set(token, forKey: "DeviceToken")

        // Pass device token to Firebase Messaging (CRITICAL for FCM token generation)
        print("📱 [APNS] Setting APNS token in Firebase Messaging...")
        Messaging.messaging().apnsToken = deviceToken
        print("✅ [APNS] APNS token set in Firebase Messaging")

        // Try to get FCM token immediately
        Messaging.messaging().token { token, error in
            if let error = error {
                print("❌ [FCM] Error after setting APNS token: \(error.localizedDescription)")
            } else if let token = token {
                print("🔥 [FCM] Token available after setting APNS token: \(token)")
            }
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ ============================================")
        print("❌ [APNS] Failed to register for remote notifications")
        print("❌ Error: \(error.localizedDescription)")
        print("❌ ============================================")

        // Check if running on simulator
        #if targetEnvironment(simulator)
        print("⚠️ [APNS] Running on Simulator - APNs not supported")
        print("⚠️ [APNS] FCM token will NOT be generated on simulator")
        print("⚠️ [APNS] Use a REAL DEVICE for push notifications")
        #endif
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Debug: Check notification and FCM status
        print("📱 ========================================")
        print("📱 [App] Application became active")
        print("📱 ========================================")

        // Check notification permission
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("🔔 [Permission] Authorization: \(settings.authorizationStatus.rawValue)")
            // 0 = notDetermined, 1 = denied, 2 = authorized, 3 = provisional
            switch settings.authorizationStatus {
            case .notDetermined:
                print("🔔 [Permission] Status: Not Determined")
            case .denied:
                print("❌ [Permission] Status: DENIED - Go to Settings to enable")
            case .authorized:
                print("✅ [Permission] Status: AUTHORIZED")
            case .provisional:
                print("✅ [Permission] Status: PROVISIONAL")
            @unknown default:
                print("⚠️ [Permission] Status: Unknown")
            }
        }

        // Check if FCM token exists
        if let fcmToken = UserDefaults.standard.string(forKey: "FCMToken") {
            print("🔥 [FCM] Token exists in UserDefaults:")
            print("🔥 \(fcmToken)")
        } else {
            print("⚠️ [FCM] No token in UserDefaults yet")
        }

        // Check if logged in
        if let customerId = AppDefaultsManager.shared.customerId {
            print("👤 [User] Logged in - Customer ID: \(customerId)")
        } else {
            print("👤 [User] Not logged in")
        }

        print("📱 ========================================")
    }

    // MARK: - URL Handling for Google Sign-In and LINE Login
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle Google Sign-In
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }

        // Handle LINE Login
        if LoginManager.shared.application(app, open: url) {
            return true
        }

        return false
    }

}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🔥 ============================================")
        print("🔥 [FCM] didReceiveRegistrationToken called")
        print("🔥 ============================================")

        guard let fcmToken = fcmToken else {
            print("❌ [FCM] Token is nil - this should not happen")
            return
        }

        print("🔥 [FCM] ✅✅✅ FCM TOKEN RECEIVED ✅✅✅")
        print("🔥 [FCM] Token: \(fcmToken)")
        print("🔥 [FCM] Token Length: \(fcmToken.count) characters")
        print("🔥 [FCM] Copy this token for testing:")
        print("🔥 ============================================")
        print(fcmToken)
        print("🔥 ============================================")

        // Store FCM token
        UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
        print("✅ [FCM] Token saved to UserDefaults")

        // Check if user is logged in before registering
        if let customerId = AppDefaultsManager.shared.customerId, !customerId.isEmpty {
            print("🔥 [FCM] User logged in (ID: \(customerId)) - registering token with backend")
            NotificationManager.shared.registerDeviceToken(fcmToken)
        } else {
            print("⚠️ [FCM] User not logged in - token stored locally, will register after login")
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Handle notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        print("📬 [Notification] Received in foreground: \(userInfo)")

        // Show notification even when app is in foreground
        if #available(iOS 14.0, *) {
            completionHandler([[.banner, .sound, .badge]])
        } else {
            completionHandler([[.alert, .sound, .badge]])
        }
    }

    // Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        print("👆 [Notification] Tapped: \(userInfo)")

        // Handle notification tap - navigate to appropriate screen
        handleNotificationTap(userInfo)

        completionHandler()
    }

    // MARK: - Handle Notification Tap
    private func handleNotificationTap(_ userInfo: [AnyHashable: Any]) {
        print("📬 [Notification] Handling notification tap with userInfo: \(userInfo)")

        // Extract notification type
        let notificationTypeString = userInfo["notificationType"] as? String
        let notificationTypeInt = Int(notificationTypeString ?? "") ?? 1

        guard let notificationType = NotificationType(rawValue: notificationTypeInt) else {
            print("⚠️ [Notification] Invalid notification type, defaulting to notification list")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                ViewNavigation.shared.showNotification()
            }
            return
        }

        print("📬 [Notification] Type: \(notificationType.description)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            switch notificationType {
            case .normal:
                // Announcements - Navigate to notification list (no redirection)
                print("📢 [Notification] Announcement - showing notification list")
                ViewNavigation.shared.showNotification()

            case .movie:
                // Movie Detail - Navigate to movie detail screen
                if let detailViewIdString = userInfo["detailViewId"] as? String,
                   let detailViewId = Int(detailViewIdString) {
                    print("🎬 [Notification] Navigating to movie detail: \(detailViewId)")
                    ViewNavigation.shared.showMovieDetail(detailType: .movie, movieId: detailViewId)
                } else {
                    print("⚠️ [Notification] Movie notification missing detailViewId")
                    ViewNavigation.shared.showNotification()
                }

            case .series:
                // Series Detail - Navigate to series detail screen
                if let detailViewIdString = userInfo["detailViewId"] as? String,
                   let detailViewId = Int(detailViewIdString) {
                    print("📺 [Notification] Navigating to series detail: \(detailViewId)")

                    // Check for episode ID
                    if let episodeIdString = userInfo["episodeId"] as? String,
                       let episodeId = Int(episodeIdString) {
                        print("📺 [Notification] Should auto-select episode: \(episodeId)")
                        // TODO: Pass episode ID to auto-select
                        ViewNavigation.shared.showMovieDetail(detailType: .series, movieId: detailViewId)
                    } else {
                        ViewNavigation.shared.showMovieDetail(detailType: .series, movieId: detailViewId)
                    }
                } else {
                    print("⚠️ [Notification] Series notification missing detailViewId")
                    ViewNavigation.shared.showNotification()
                }
            }
        }
    }
}

