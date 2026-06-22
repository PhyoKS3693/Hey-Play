//
//  NotificationManager.swift
//  HeyPlay
//
//  Created by Claude on 18/06/2026.
//

import Foundation
import FirebaseMessaging
import UserNotifications

final class NotificationManager {

    static let shared = NotificationManager()

    private init() {}

    // MARK: - Get FCM Token
    var fcmToken: String? {
        return UserDefaults.standard.string(forKey: "FCMToken")
    }

    // MARK: - Get Device Token
    var deviceToken: String? {
        return UserDefaults.standard.string(forKey: "DeviceToken")
    }

    // MARK: - Register Device Token with Backend
    func registerDeviceToken(_ token: String) {
        guard let customerId = AppDefaultsManager.shared.customerId,
              !customerId.isEmpty else {
            print("⚠️ [NotificationManager] No customer ID - skipping device token registration")
            return
        }

        print("📤 [NotificationManager] Registering FCM token with backend: \(token)")

        Task {
            let result = await AuthService.shared.registerDeviceToken(
                fcmToken: token,
                deviceType: "2" // iOS = 2
            )

            switch result {
            case .success:
                print("✅ [NotificationManager] Device token registered successfully")
            case .failure(let error):
                print("❌ [NotificationManager] Failed to register device token: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Check Notification Permission Status
    func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                completion(true)
            case .denied, .notDetermined:
                completion(false)
            @unknown default:
                completion(false)
            }
        }
    }

    // MARK: - Request Notification Permission
    func requestNotificationPermission(completion: @escaping (Bool, Error?) -> Void) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                completion(granted, error)

                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        )
    }

    // MARK: - Clear Badge Count
    func clearBadge() {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }

    // MARK: - Update Badge Count
    func updateBadge(count: Int) {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}
