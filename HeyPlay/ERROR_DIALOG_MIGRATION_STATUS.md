# Custom Error Dialog Migration Status

## ✅ COMPLETED (7 items)

### Services with Error Extraction
1. ✅ **AuthService.swift** - Login OTP verify extracts error messages
2. ✅ **ProfileService.swift** - Both getProfile() and updateProfile() extract error messages
3. ✅ **PhoneChangeService.swift** - Both validateNewPhone() and updatePhoneNumber() extract error messages
4. ✅ **RedeemCodeService.swift** - Redeem code extracts error messages

### Screens Using Custom Error Dialog
5. ✅ **ProfileScreen.swift** - Uses ErrorManager.shared.showError()
6. ✅ **SearchView.swift** - Updated to use ErrorManager (just completed)
7. ✅ **MovieSeriesTabView.swift** - Updated to use ErrorManager (just completed)

---

## 📋 REMAINING WORK

### High Priority Screens (6 screens)

#### 1. LoginView.swift
**Location**: `Modules/Login/Controller/LoginView.swift` (Lines 90-99)
**Current**: Uses `.alert("Error", isPresented: ...)`
**Action Needed**:
```swift
// Add at top:
@ObservedObject private var errorManager = ErrorManager.shared

// Replace .alert() with:
.errorDialog($errorManager.currentError)
.onChange(of: viewModel.errorMessage) { error in
    if let errorMsg = error {
        ErrorManager.shared.showError(title: "Login Failed", message: errorMsg)
        viewModel.errorMessage = nil
    }
}
```

#### 2. BuyPlanViewScreen.swift
**Location**: `Modules/SubscriptionPlan/BuyPlan/BuyPlanViewScreen.swift` (Lines 161-170)
**Current**: Uses `.alert("Error", isPresented: ...)`
**Action Needed**: Same pattern as above, change title to "Purchase Failed"

#### 3. MenuScreen.swift - Redemption Code Error
**Location**: `Modules/Menu/MenuScreen.swift` (Lines 490-491)
**Current**: Shows error in custom dialog but uses local state
**Action Needed**: Use ErrorManager for consistency

#### 4. OTPView.swift
**Location**: `Modules/OTP/OTPView.swift` (Lines 137-143)
**Current**: Uses custom `WrongOTPAlertView`
**Action Needed**: Already has custom alert - can optionally migrate to ErrorManager

#### 5. VerifyOtpScreen.swift
**Location**: `Modules/ChangePhoneNumber/VerifyOtpScreen.swift` (Lines 122-128)
**Current**: Uses custom `WrongOTPAlertView`
**Action Needed**: Already has custom alert - can optionally migrate to ErrorManager

#### 6. VIPHistoryScreen.swift
**Location**: `Modules/VIPHistory/VIPHistoryScreen.swift` (Lines 188-197)
**Current**: Uses `.alert("Error", isPresented: ...)`
**Action Needed**: Same pattern as SearchView

---

### Medium Priority Screens (5 screens)

#### 7. AboutUsScreen.swift
**Location**: `Modules/AboutUs/AboutUsScreen.swift` (Lines 51-60)
**Action Needed**: Standard alert → ErrorManager

#### 8. PoliciesScreen.swift
**Location**: `Modules/Policies/PoliciesScreen.swift` (Lines 51-60)
**Action Needed**: Standard alert → ErrorManager

#### 9. SubscriptionScreen.swift
**Location**: `Modules/SubscriptionPlan/SubscriptionScreen.swift` (Lines 66-75)
**Action Needed**: Standard alert → ErrorManager

#### 10. PackageScreen.swift
**Location**: `Modules/SubscriptionPlan/Package/PackageScreen.swift` (Lines 76-85)
**Action Needed**: Standard alert → ErrorManager

#### 11. PlanViewScreen.swift
**Location**: `Modules/SubscriptionPlan/Plan/PlanViewScreen.swift` (Lines 104-113)
**Action Needed**: Standard alert → ErrorManager

---

### Services Needing Error Extraction (11 services)

All services need to extract error messages from `errors` array. Pattern:

```swift
} else {
    // Extract error message from errors array if available
    let errorMessage: String
    if let errors = apiResponse.errors, let firstError = errors.first {
        errorMessage = firstError.errorMessage
        print("❌ [ServiceName] Failed with fieldCode \(firstError.fieldCode): \(errorMessage)")
    } else {
        errorMessage = apiResponse.responseMessage
        print("❌ [ServiceName] Failed: \(errorMessage)")
    }
    return .failure(APIError.serverError(errorMessage))
}
```

#### Services List:
1. **SubscriptionPlanService.swift** - 4 methods
2. **HomeService.swift** - 2 methods
3. **FavouriteService.swift** - 3 methods
4. **WatchLaterService.swift** - 4 methods
5. **SearchService.swift** - 3 methods
6. **ContentService.swift** - 2 methods
7. **ReelService.swift** - 1 method
8. **SupportService.swift** - 1 method
9. **NotificationService.swift** - 2 methods
10. **LastWatchService.swift** - 4 methods

---

## 🎨 Optional: UIKit Screens (3 controllers)

These use UIAlertController and can optionally be migrated to use `ErrorPresenter`:

1. **HomeViewController.swift** (Lines 129-150)
2. **HotViewController.swift** (Lines 113-140)
3. **CollectionResultViewController.swift** (Lines 94-118)

**Migration Pattern**:
```swift
// Replace UIAlertController with:
self.showErrorDialog(
    title: "Error",
    message: errorMessage
)
```

---

## 📊 Progress Summary

- **Total Items**: 25 (11 screens + 11 services + 3 UIKit controllers)
- **Completed**: 7 (28%)
- **Remaining**: 18 (72%)

### Breakdown:
- ✅ Services: 4/15 (27%)
- ✅ SwiftUI Screens: 3/13 (23%)
- ⏳ UIKit Screens: 0/3 (optional)

---

## 🚀 Quick Start Guide

### For Each Screen:

1. **Add ErrorManager**:
   ```swift
   @ObservedObject private var errorManager = ErrorManager.shared
   ```

2. **Remove old .alert()**

3. **Add custom error dialog**:
   ```swift
   .errorDialog($errorManager.currentError)
   .onChange(of: viewModel.errorMessage) { error in
       if let errorMsg = error {
           ErrorManager.shared.showError(title: "Error", message: errorMsg)
           viewModel.errorMessage = nil
       }
   }
   ```

### For Each Service:

1. Find all `return .failure(APIError.serverError(apiResponse.responseMessage))`

2. Replace with error extraction logic (see pattern above)

3. Test to ensure error messages are displayed correctly

---

## ✨ Benefits After Full Migration

1. **Consistent UI** - All errors use the same beautiful dialog
2. **Better UX** - Professional error presentation with icon
3. **Accurate Messages** - Shows actual API error messages, not generic "Success"
4. **Easy Maintenance** - One place to update error dialog design
5. **Type Safety** - Compile-time safety with APIErrorModel

---

## 📝 Testing Checklist

After migrating each screen/service:

- [ ] Error dialog appears with correct styling
- [ ] Error message is specific and helpful
- [ ] Dialog dismisses on OK button
- [ ] No duplicate error dialogs
- [ ] Error icon displays correctly
- [ ] Colors match design (pink button, dark background)

---

## 🔗 Reference Files

- **Error Dialog Component**: `Common/CustomErrorDialog.swift`
- **Error Manager**: `Common/ErrorManager.swift`
- **Error Presenter (UIKit)**: `Common/ErrorPresenter.swift`
- **Usage Guide**: `ERROR_DIALOG_USAGE.md`
- **Migration Plan**: `MIGRATION_PLAN.md`
- **Reference Implementation**: `ProfileScreen.swift` (lines 200-206)

---

Last Updated: 2026-06-18
