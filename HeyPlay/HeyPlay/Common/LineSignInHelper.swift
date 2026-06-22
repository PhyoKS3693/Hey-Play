//
//  LineSignInHelper.swift
//  HeyPlay
//
//  Created by Claude Code on 06/15/26.
//

import Foundation
import UIKit
import LineSDK

class LineSignInHelper {

    static let shared = LineSignInHelper()

    // LINE Channel ID
    private let channelID = "2000867689"

    private init() {}

    // MARK: - LINE Sign In
    @MainActor
    func signIn(completion: @escaping (Result<LineUserInfo, Error>) -> Void) {
        // Set up LINE SDK login permissions
        let permissions: Set<LoginPermission> = [.profile]

        // Start LINE login
        LoginManager.shared.login(permissions: permissions, in: nil) { result in
            switch result {
            case .success(let loginResult):
                // Get user profile
                self.getUserProfile(accessToken: loginResult.accessToken.value) { profileResult in
                    switch profileResult {
                    case .success(let userInfo):
                        completion(.success(userInfo))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Get User Profile
    private func getUserProfile(accessToken: String, completion: @escaping (Result<LineUserInfo, Error>) -> Void) {
        API.getProfile { result in
            switch result {
            case .success(let profile):
                let userInfo = LineUserInfo(
                    lineUserId: profile.userID,
                    displayName: profile.displayName,
                    pictureURL: profile.pictureURL?.absoluteString,
                    statusMessage: profile.statusMessage
                )
                completion(.success(userInfo))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Sign Out
    func signOut() {
        LoginManager.shared.logout { result in
            switch result {
            case .success:
                print("✅ [LINE] Logged out successfully")
            case .failure(let error):
                print("❌ [LINE] Logout failed: \(error)")
            }
        }
    }

    // MARK: - Check if user is logged in
    var isLoggedIn: Bool {
        return AccessTokenStore.shared.current != nil
    }
}

// MARK: - LINE User Info Model
struct LineUserInfo {
    let lineUserId: String
    let displayName: String
    let pictureURL: String?
    let statusMessage: String?
}
