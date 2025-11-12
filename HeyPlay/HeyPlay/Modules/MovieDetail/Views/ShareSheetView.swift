//
//  ShareSheetView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 05/11/2025.
//

import SwiftUI
import UIKit

// MARK: - UIViewControllerRepresentable wrapper
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    var excludedActivityTypes: [UIActivity.ActivityType]? = nil
    var completion: ((UIActivity.ActivityType?, Bool, [Any]?, Error?) -> Void)? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems,
                                                  applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = { activityType, completed, returnedItems, error in
            completion?(activityType, completed, returnedItems, error)
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to update
    }
}

// MARK: - Example usage in SwiftUI view
struct ContentView: View {
    @State private var showingShare = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Share sheet example (iOS 13)")
                .font(.headline)

            Button("Share text & link") {
                showingShare = true
            }
        }
        .sheet(isPresented: $showingShare) {
            // Items to share:
            let text = "Check out this great link!"
            let url = URL(string: "https://example.com")!
            ActivityView(activityItems: [text, url],
                         excludedActivityTypes: [.assignToContact, .addToReadingList]) { activity, completed, items, error in
                if completed {
                    print("Shared via:", activity?.rawValue ?? "unknown")
                } else {
                    print("Share cancelled")
                }
                if let err = error {
                    print("Share error:", err)
                }
            }
        }
    }
}

// Preview (works in Xcode canvas)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
