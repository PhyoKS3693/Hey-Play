//
//  GoogleSignInHelper.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 05/29/26.
//

import Foundation
import UIKit
import GoogleSignIn

class GoogleSignInHelper {

    static let shared = GoogleSignInHelper()

    private init() {}

    // MARK: - Google Sign In
    func signIn(presenting viewController: UIViewController, completion: @escaping (Result<GoogleUserInfo, Error>) -> Void) {
        // Get the client ID from your GoogleService-Info.plist
        guard let clientID = getClientID() else {
            completion(.failure(NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Client ID not found. Please add GoogleService-Info.plist"])))
            return
        }

        // Create Google Sign In configuration
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user else {
                completion(.failure(NSError(domain: "GoogleSignIn", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to get user information"])))
                return
            }

            // Extract user information
            let googleUserInfo = GoogleUserInfo(
                googleId: user.userID ?? "",
                email: user.profile?.email ?? "",
                name: user.profile?.name ?? "",
                profileImage: user.profile?.imageURL(withDimension: 200)?.absoluteString
            )

            completion(.success(googleUserInfo))
        }
    }

    // MARK: - Sign Out
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }

    // MARK: - Get Client ID from GoogleService-Info.plist
    private func getClientID() -> String? {
        // Try to get from GoogleService-Info.plist
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path) as? [String: Any] {

            // Try CLIENT_ID first (standard field)
            if let clientID = plist["CLIENT_ID"] as? String {
                print("✅ [GoogleSignIn] Found CLIENT_ID in GoogleService-Info.plist")
                return clientID
            }
        }

        print("❌ [GoogleSignIn] CLIENT_ID not found in GoogleService-Info.plist")
        return nil
    }
}

// MARK: - Google User Info Model
struct GoogleUserInfo {
    let googleId: String
    let email: String
    let name: String
    let profileImage: String?
}
