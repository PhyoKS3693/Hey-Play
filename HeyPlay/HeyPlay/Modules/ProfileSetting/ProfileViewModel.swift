//
//  ProfileViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import Foundation
import Combine
import UIKit

final class ProfileViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var profile: Profile?

    // MARK: - Callbacks
    var onUpdateSuccess: (() -> Void)?

    // MARK: - Computed Properties
    var isLoggedIn: Bool {
        return AppDefaultsManager.shared.isLoggedIn
    }

    var userName: String {
        return profile?.safeName ?? "Guest"
    }

    var userPlan: String {
        return profile?.safePlanName ?? "Free"
    }

    var profileImageURL: String? {
        return profile?.fullProfileImageURL
    }

    var subscriptionStatus: Profile.SubscriptionStatus {
        return profile?.subscriptionStatus ?? .free
    }

    // MARK: - API Calls
    func fetchProfile() {
        guard isLoggedIn else {
            profile = nil
            return
        }

        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            let result = await ProfileService.shared.getProfile()

            isLoading = false

            switch result {
            case .success(let data):
                self.profile = data
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Update Profile
    func updateProfile(name: String, email: String?, gender: Int? = nil, profileImage: String? = nil) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Name cannot be empty"
            return
        }

        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        print("📝 [ProfileViewModel] Updating profile - name: \(name), profileImage: \(profileImage != nil ? "present" : "nil")")
        print("📝 [ProfileViewModel] Email field is disabled and will not be updated")

        Task { @MainActor in
            // Only send name and profileImage, ignore email
            let result = await ProfileService.shared.updateProfile(
                name: name,
                email: nil,  // Don't send email
                gender: nil, // Don't send gender
                profileImage: profileImage
            )

            isLoading = false

            switch result {
            case .success(let updatedProfile):
                print("✅ [ProfileViewModel] Profile updated successfully")
                self.profile = updatedProfile
                // Clear any error messages before navigating back
                self.errorMessage = nil
                // Call success callback to navigate back
                self.onUpdateSuccess?()
            case .failure(let error):
                print("❌ [ProfileViewModel] Update failed: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Convert Image to Base64
    func convertImageToBase64(_ image: UIImage) -> String? {
        // Resize image to reasonable size (max 1024x1024) to reduce file size
        let resizedImage = resizeImage(image, targetSize: CGSize(width: 1024, height: 1024))

        // Convert to JPEG with 80% quality
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.8) else {
            print("❌ [ProfileViewModel] Failed to convert image to data")
            return nil
        }

        let base64String = imageData.base64EncodedString()
        print("📷 [ProfileViewModel] Image converted to base64, size: \(imageData.count) bytes")
        return base64String
    }

    // MARK: - Resize Image
    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Determine what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // Only resize if image is larger than target
        if newSize.width >= size.width && newSize.height >= size.height {
            return image
        }

        // Create the new image
        let rect = CGRect(origin: .zero, size: newSize)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? image
    }

    // MARK: - Logout
    func logout() {
        AppDefaultsManager.shared.logout()
        profile = nil
        ViewNavigation.shared.showLoginView()
    }
}
