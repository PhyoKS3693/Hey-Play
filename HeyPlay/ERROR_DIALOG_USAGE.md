# Custom Error Dialog Usage Guide

This guide explains how to use the custom error dialog throughout the HeyPlay app.

## Overview

The custom error dialog provides a consistent, beautiful error presentation that matches the app's design language. It's similar to the OTP error dialog and can be used from both SwiftUI views and UIKit view controllers.

## Components

1. **CustomErrorDialog** - SwiftUI component
2. **ErrorManager** - Global state manager (for SwiftUI)
3. **ErrorPresenter** - UIKit presenter (for UIViewControllers)
4. **APIErrorModel** - Error data model

---

## Usage in SwiftUI Views

### Method 1: Using ErrorManager (Global State)

Add the error dialog modifier to your view and observe the global ErrorManager:

```swift
struct MySwiftUIView: View {
    @ObservedObject private var errorManager = ErrorManager.shared

    var body: some View {
        VStack {
            // Your content here
        }
        .errorDialog($errorManager.currentError)
    }
}
```

Show error from anywhere:

```swift
// From ViewModel or anywhere in the app
ErrorManager.shared.showError(
    title: "Login Failed",
    message: "Invalid credentials. Please try again."
)

// Or from an Error object
ErrorManager.shared.showError(error, title: "Network Error")
```

### Method 2: Using Local State

```swift
struct MyView: View {
    @State private var error: APIErrorModel?

    var body: some View {
        VStack {
            Button("Test Error") {
                error = APIErrorModel(
                    title: "Test Error",
                    message: "This is a test error message"
                )
            }
        }
        .errorDialog($error)
    }
}
```

### Example: Login View with Error Dialog

```swift
struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @ObservedObject private var errorManager = ErrorManager.shared

    var body: some View {
        VStack {
            // Login UI
        }
        .errorDialog($errorManager.currentError)
        .onChange(of: viewModel.errorMessage) { error in
            if let errorMsg = error {
                ErrorManager.shared.showError(message: errorMsg)
            }
        }
    }
}
```

---

## Usage in UIKit View Controllers

### Basic Usage

```swift
class MyViewController: UIViewController {

    func someAPICall() {
        // When API fails
        self.showErrorDialog(
            title: "Error",
            message: "Failed to load data. Please try again."
        )
    }

    func anotherAPICall() {
        SomeService.shared.fetchData { result in
            switch result {
            case .success(let data):
                // Handle success
                break
            case .failure(let error):
                // Show error dialog
                self.showErrorDialog(error, title: "Loading Failed")
            }
        }
    }
}
```

### With Confirmation Callback

```swift
self.showErrorDialog(
    title: "Session Expired",
    message: "Your session has expired. Please login again.",
    onConfirm: {
        // Navigate to login screen
        ViewNavigation.shared.showLoginView()
    }
)
```

### Example: Profile View Controller

```swift
class ProfileViewController: UIViewController {

    func updateProfile() {
        ProfileService.shared.updateProfile(data) { [weak self] result in
            switch result {
            case .success:
                // Show success message
                break
            case .failure(let error):
                // Show error dialog with API error message
                self?.showErrorDialog(
                    title: "Update Failed",
                    message: error.localizedDescription
                )
            }
        }
    }
}
```

---

## Usage in ViewModels

### For SwiftUI ViewModels

```swift
class MyViewModel: ObservableObject {
    @Published var errorMessage: String?

    func performAction() async {
        let result = await SomeService.shared.doSomething()

        switch result {
        case .success:
            // Handle success
            break
        case .failure(let error):
            // Set error message (View will observe and show dialog)
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }

            // OR use ErrorManager directly
            ErrorManager.shared.showError(error)
        }
    }
}
```

### For UIKit ViewControllers with Closures

```swift
class MyViewModel {
    var onError: ((String) -> Void)?

    func fetchData() {
        APIClient.request(...) { [weak self] result in
            switch result {
            case .success:
                break
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}

// In ViewController:
viewModel.onError = { [weak self] errorMessage in
    self?.showErrorDialog(message: errorMessage)
}
```

---

## API Service Integration

### Extract Error Message from API Response

When API returns error with `errors` array:

```swift
func someAPICall() async -> Result<Data, Error> {
    let response = await APIClient.shared.request(...)

    switch response.result {
    case .success(let apiResponse):
        if apiResponse.isSuccess, let data = apiResponse.data {
            return .success(data)
        } else {
            // Extract error message from errors array
            let errorMessage: String
            if let errors = apiResponse.errors, let firstError = errors.first {
                errorMessage = firstError.errorMessage
            } else {
                errorMessage = apiResponse.responseMessage
            }
            return .failure(APIError.serverError(errorMessage))
        }
    case .failure(let error):
        return .failure(error)
    }
}
```

---

## Complete Examples

### Example 1: Home Screen with Error Dialog

```swift
struct HomeScreen: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject private var errorManager = ErrorManager.shared

    var body: some View {
        ScrollView {
            // Home content
        }
        .errorDialog($errorManager.currentError)
        .onAppear {
            viewModel.fetchData()
        }
        .onChange(of: viewModel.errorMessage) { error in
            if let errorMsg = error {
                ErrorManager.shared.showError(
                    title: "Loading Failed",
                    message: errorMsg
                )
            }
        }
    }
}
```

### Example 2: Login with Error Handling

```swift
// ViewModel
class LoginViewModel: ObservableObject {
    @Published var errorMessage: String?

    func login() {
        Task {
            let result = await AuthService.shared.login(...)

            switch result {
            case .success:
                // Navigate to home
                break
            case .failure(let error):
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

// View
struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @ObservedObject private var errorManager = ErrorManager.shared

    var body: some View {
        VStack {
            // Login UI
        }
        .errorDialog($errorManager.currentError)
        .onChange(of: viewModel.errorMessage) { error in
            if let errorMsg = error {
                ErrorManager.shared.showError(
                    title: "Login Failed",
                    message: errorMsg
                )
            }
        }
    }
}
```

### Example 3: UIKit View Controller

```swift
class SettingsViewController: UIViewController {

    func saveSettings() {
        SettingsService.shared.save(settings) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // Show success
                    break
                case .failure(let error):
                    self?.showErrorDialog(
                        title: "Save Failed",
                        message: error.localizedDescription,
                        onConfirm: {
                            // Optional: Do something after user taps OK
                        }
                    )
                }
            }
        }
    }
}
```

---

## Benefits

1. **Consistent UI** - Same error presentation across the entire app
2. **Easy to Use** - Simple API for both SwiftUI and UIKit
3. **Centralized** - Can be called from anywhere (ViewModels, Services, Views)
4. **Customizable** - Easy to modify appearance in one place
5. **Type-Safe** - Uses Swift's strong typing

---

## Migration from Old Error Handling

### Before (UIAlertController)
```swift
let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
alert.addAction(UIAlertAction(title: "OK", style: .default))
present(alert, animated: true)
```

### After (Custom Error Dialog)
```swift
showErrorDialog(message: errorMsg)
```

### Before (SwiftUI Alert)
```swift
.alert("Error", isPresented: $showError) {
    Button("OK") { }
} message: {
    Text(errorMessage)
}
```

### After (Custom Error Dialog)
```swift
.errorDialog($errorManager.currentError)
// Then trigger with:
ErrorManager.shared.showError(message: errorMessage)
```

---

## Best Practices

1. **Always use the custom error dialog** instead of UIAlertController or SwiftUI Alert for errors
2. **Extract error messages from API** errors array when available
3. **Provide clear, user-friendly error messages**
4. **Use appropriate titles** (e.g., "Login Failed", "Network Error", "Loading Failed")
5. **Clear error state** after showing to prevent duplicate displays

---

## Notes

- The error dialog uses the same design as the OTP error dialog
- Icon used: `ic.otpError` (error icon image)
- Background color: Dark gray (#1C1C1E)
- Primary button color: Pink (`pink_Color`)
- Supports multi-line error messages
- Auto-dismisses when user taps OK or close button
