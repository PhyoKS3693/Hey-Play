//
//  ErrorManager.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Error Manager
class ErrorManager: ObservableObject {
    static let shared = ErrorManager()

    @Published var currentError: APIErrorModel?

    private init() {}

    // Show error dialog
    func showError(title: String = "Error", message: String) {
        DispatchQueue.main.async {
            self.currentError = APIErrorModel(title: title, message: message)
        }
    }

    // Show error from Error object
    func showError(_ error: Error, title: String = "Error") {
        let message = error.localizedDescription
        showError(title: title, message: message)
    }

    // Clear error
    func clearError() {
        DispatchQueue.main.async {
            self.currentError = nil
        }
    }
}
