//
//  AppleSignInHelper.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 05/29/26.
//

import Foundation
import UIKit
import AuthenticationServices

class AppleSignInHelper: NSObject {

    static let shared = AppleSignInHelper()

    private var completion: ((Result<AppleUserInfo, Error>) -> Void)?
    private weak var presentingViewController: UIViewController?

    private override init() {
        super.init()
    }

    // MARK: - Apple Sign In
    func signIn(presenting viewController: UIViewController, completion: @escaping (Result<AppleUserInfo, Error>) -> Void) {
        self.completion = completion
        self.presentingViewController = viewController

        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    // MARK: - Sign Out
    func signOut() {
        // Apple doesn't have a sign out method
        // The user must revoke access from their Apple ID settings
        print("ℹ️ [AppleSignIn] Apple Sign-In doesn't have a sign out method")
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AppleSignInHelper: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            completion?(.failure(NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get Apple ID credential"])))
            return
        }

        // Get user identifier (Apple ID)
        let appleId = appleIDCredential.user

        // Get email (only provided on first sign-in)
        let email = appleIDCredential.email ?? ""

        // Get full name (only provided on first sign-in)
        var fullName = ""
        if let givenName = appleIDCredential.fullName?.givenName,
           let familyName = appleIDCredential.fullName?.familyName {
            fullName = "\(givenName) \(familyName)"
        } else if let givenName = appleIDCredential.fullName?.givenName {
            fullName = givenName
        }

        // Check if this is first sign-in (email and name provided)
        let isFirstSignIn = !email.isEmpty || !fullName.isEmpty

        print("✅ [AppleSignIn] Sign-In successful")
        print("   Apple ID: \(appleId)")
        print("   Email: \(email.isEmpty ? "(not provided - subsequent login)" : email)")
        print("   Name: \(fullName.isEmpty ? "(not provided - subsequent login)" : fullName)")
        print("   First Sign-In: \(isFirstSignIn)")

        if !isFirstSignIn {
            print("ℹ️ [AppleSignIn] This is a subsequent sign-in. Email and name should be retrieved from your backend using Apple ID.")
        }

        let appleUserInfo = AppleUserInfo(
            appleId: appleId,
            email: email,
            name: fullName,
            isFirstSignIn: isFirstSignIn
        )

        completion?(.success(appleUserInfo))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ [AppleSignIn] Sign-In failed: \(error.localizedDescription)")

        // Check if user cancelled
        if let authError = error as? ASAuthorizationError {
            switch authError.code {
            case .canceled:
                print("ℹ️ [AppleSignIn] User cancelled sign-in")
            case .unknown:
                print("⚠️ [AppleSignIn] Unknown error")
            case .invalidResponse:
                print("⚠️ [AppleSignIn] Invalid response")
            case .notHandled:
                print("⚠️ [AppleSignIn] Not handled")
            case .failed:
                print("⚠️ [AppleSignIn] Failed")
            @unknown default:
                print("⚠️ [AppleSignIn] Unknown case")
            }
        }

        completion?(.failure(error))
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AppleSignInHelper: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentingViewController?.view.window ?? UIWindow()
    }
}

// MARK: - Apple User Info Model
struct AppleUserInfo {
    let appleId: String
    let email: String
    let name: String
    let isFirstSignIn: Bool
}
