# API to UI Binding Status

## ✅ Already Bound to UI (Working)

### 1. **HomeViewModel** ✅
- **Service**: `HomeService`, `ProfileService`
- **APIs Used**:
  - `getHomeData()` - Fetches banners, playlists, last watch
  - `getProfile()` - Fetches user profile
- **Status**: Fully integrated and working

### 2. **HotViewModel** ✅
- **Service**: `ReelService`
- **APIs Used**:
  - `getReelList(pageNo:)` - Fetches reels with pagination
- **Status**: Integrated
- **Missing**: Favorite and Watch Later toggle (see TODOs below)

### 3. **MovieDetailViewModel** ✅
- **Service**: `ContentService`
- **APIs Used**:
  - `getContentDetail(movieId:)` - Fetches movie/series details
- **Status**: Integrated
- **Missing**: Favorite and Watch List toggle (see TODOs below)

### 4. **ProfileViewModel** ✅
- **Service**: `ProfileService`
- **APIs Used**:
  - `getProfile()` - Fetches user profile
- **Status**: Fully integrated

### 5. **CollectionResultViewController** ✅
- **Service**: `HomeService`
- **APIs Used**:
  - `getPlaylistDetail(playlistId:pageNo:)` - Fetches playlist movies
- **Status**: Fully integrated with pagination

---

## ⚠️ TODOs - Need API Binding

### 6. **MovieDetailViewModel** - Missing Actions
**Location**: `HeyPlay/Modules/MovieDetail/ViewModel/MovieDetailViewModel.swift:100-110`

```swift
// MARK: - Toggle Favourite
func toggleFavourite() {
    // TODO: Call API to toggle favourite
    print("Toggle favourite for movie: \(movieId)")
}

// MARK: - Toggle Watch List
func toggleWatchList() {
    // TODO: Call API to toggle watch list
    print("Toggle watch list for movie: \(movieId)")
}
```

**Needs**:
- `FavouriteService.addFavourite(movieId:)` or `removeFavourite(movieId:)`
- `WatchLaterService.addWatchLater(movieId:)` or `deleteWatchLater(id:)`

---

### 7. **HotViewModel** - Missing Actions
**Location**: `HeyPlay/Modules/Hot/ViewModel/HotViewModel.swift:93-104`

```swift
// MARK: - Toggle Favorite
func toggleFavorite(at index: Int) {
    guard index < reels.count else { return }
    // TODO: Implement favorite API call
    print("Toggle favorite for reel: \(reels[index].id)")
}

// MARK: - Toggle Watch Later
func toggleWatchLater(at index: Int) {
    guard index < reels.count else { return }
    // TODO: Implement watch later API call
    print("Toggle watch later for reel: \(reels[index].id)")
}
```

**Needs**:
- `FavouriteService.addFavourite(reelId:)` or `removeFavourite(reelId:)`
- Note: Watch Later might not apply to reels (check requirements)

---

## ❌ Empty ViewModels - Need Full Implementation

### 8. **RedemptionCodeViewModel** ❌
**Location**: `HeyPlay/Modules/RedemptionCode/RedemptionCodeViewModel.swift`
**Current**: Empty class
**Needs**:
- `RedeemCodeService.redeemPromoCode(promoCode:)`
- Add properties: `@Published var isLoading, errorMessage, redemptionResult`
- Add method: `redeemCode(promoCode: String)`

---

### 9. **WatchListViewModel** ❌
**Location**: `HeyPlay/Modules/WatchList/WatchListViewModel.swift`
**Current**: Empty class

**Needs** (Choose based on requirements):

**Option A: Watch Later List**
- `WatchLaterService.getWatchLaterList(pageNo:)`
- `WatchLaterService.deleteWatchLater(id:)`
- `WatchLaterService.deleteAllWatchLater()`

**Option B: Last Watch List**
- `LastWatchService.getLastWatchList(pageNo:)`
- `LastWatchService.deleteLastWatch(lastWatchId:)`
- `LastWatchService.deleteAllLastWatch()`

**Option C: Favorites List**
- `FavouriteService.getFavouriteList(pageNo:)`
- `FavouriteService.removeFavourite(movieId:reelId:)`

*Note: Check UI to determine which one is needed*

---

### 10. **VIPHistoryViewModel** ❌
**Location**: `HeyPlay/Modules/VIPHistory/VIPHistoryViewModel.swift`
**Current**: Empty class
**Needs**:
- `SubscriptionPlanService.getPackageHistory(fromDate:toDate:)`
- Add properties: `@Published var isLoading, errorMessage, packageHistory`
- Add method: `fetchPackageHistory(fromDate:toDate:)`

---

### 11. **ChangePhoneNumberViewModel** ❌
**Location**: `HeyPlay/Modules/ChangePhoneNumber/ChangePhoneNumberViewModel.swift`
**Current**: Empty class
**Needs**:
- `PhoneChangeService.validateNewPhone(newPhone:)` - Step 1
- `PhoneChangeService.updatePhoneNumber(newPhone:otp:securityKey:)` - Step 2
- Add properties: `@Published var isLoading, errorMessage, securityKey`
- Add methods: `validatePhone(newPhone:)`, `updatePhone(newPhone:otp:)`

---

### 12. **VideoPlayerViewModel** ❌
**Location**: `HeyPlay/Modules/VideoPlayer/ViewModel/VideoPlayerViewModel.swift`
**Current**: Empty class
**Needs**:
- `ContentService.watchContent(movieId:episodeId:)` - Get streaming URL
- `LastWatchService.addLastWatch(movieId:movieEpisodeId:lastWatchTimeStamps:)` - Track progress
- Add properties: `@Published var isLoading, streamingUrl, watchData`
- Add methods: `fetchStreamingUrl(movieId:episodeId:)`, `saveWatchProgress(timestamp:)`

---

### 13. **NotificationViewModel** ❌
**Location**: `HeyPlay/Modules/Notification/Views/NotificationViewModel.swift`
**Current**: Using dummy data (mock)

```swift
final class NotificationViewModel: ObservableObject {
    var notificationItems = [NotificationItem]()
    init () {
        for index in 0..<10 {
            notificationItems.append(
                NotificationItem(
                    title: "Notifiation \(index)",
                    message: "Lorem Ipsum is simply dummy text...")
            )
        }
    }
}
```

**Needs**:
- Replace with `NotificationService.getNotificationList(pageNo:)`
- Update to use `APINotification` from response models
- Add properties: `@Published var isLoading, errorMessage, notifications`
- Add methods: `fetchNotifications()`, `loadMore()`

---

### 14. **SubscriptionViewModel** ⚠️
**Location**: `HeyPlay/Modules/SubscriptionPlan/SubscriptionViewModel.swift`
**Current**: Using hardcoded data

```swift
@Published var subscriptionPlans: [SubscriptionPlan] = [
    // FREE PLAN
    SubscriptionPlan(title: "Free Plan", badge: "Limited", ...),
    // VIP PLAN
    SubscriptionPlan(title: "VIP Plan", badge: "Unlimited", ...)
]
```

**Needs**:
- `SubscriptionPlanService.getSubscriptionPlanPreload()` - Get packages and payment methods
- `SubscriptionPlanService.buyPackage(paymentMethodId:packageId:)` - Purchase
- Replace hardcoded data with API data
- Add methods: `fetchPlans()`, `buyPlan(packageId:paymentMethodId:)`

---

### 15. **AboutUsViewModel** ❌
**Location**: `HeyPlay/Modules/AboutUs/AboutUsViewModel.swift`
**Current**: Empty class
**Needs** (if support contacts shown here):
- `SupportService.getSupportList()` - Get support/contact info
- Add properties: `@Published var supportItems`
- Add method: `fetchSupportInfo()`

---

## 🚫 No ViewModel Found - May Need Creation

### 16. **Login/OTP Flow** 🔍
**Current Modules**: `Login`, `OTP`
**Files Found**: `LoginViewController.swift`, `LoginView.swift`
**Status**: No ViewModel found

**Needs**:
- Create `LoginViewModel` with `AuthService`
- APIs:
  - `validatePhoneBeforeLogin(phoneNo:)` - Step 1
  - `loginOTPVerify(phoneNo:securityKey:otpCode:...)` - Step 2
  - `loginWithGoogle(...)` - Google login
  - `loginWithApple(...)` - Apple login

---

### 17. **Search Feature** 🔍
**Current**: No Search module found
**May exist in**: Menu or separate screen

**Needs** (if exists):
- Create `SearchViewModel` with `SearchService`
- APIs:
  - `searchContents(searchKey:pageNo:movieType:movieOrigin:)`
  - `getSearchPreload()` - Get filters/categories
  - `saveSearchHistory(searchString:)` - Save search

---

## 📊 Summary Statistics

| Status | Count | ViewModels |
|--------|-------|------------|
| ✅ Fully Integrated | 5 | Home, Hot, MovieDetail, Profile, CollectionResult |
| ⚠️ Partial (TODOs) | 2 | MovieDetail (toggles), Hot (toggles) |
| ❌ Empty/Mock | 9 | RedemptionCode, WatchList, VIPHistory, ChangePhone, VideoPlayer, Notification, Subscription, AboutUs, Login |
| 🔍 Not Found | 1 | Search |

**Total APIs Integrated**: 10/15 services have UIs
**Total APIs Needing Binding**: 11 ViewModels need implementation

---

## 🎯 Priority Implementation Order

### High Priority (User-facing features):
1. **VideoPlayerViewModel** - Core feature (watch content)
2. **NotificationViewModel** - Replace mock data
3. **Login/OTP** - Create ViewModel for auth flow
4. **WatchListViewModel** - User library management
5. **MovieDetail/Hot toggles** - Favorite & Watch Later

### Medium Priority:
6. **SubscriptionViewModel** - Replace hardcoded data
7. **VIPHistoryViewModel** - Purchase history
8. **RedemptionCodeViewModel** - Promo codes
9. **ChangePhoneNumberViewModel** - Account management

### Low Priority:
10. **AboutUsViewModel** - Support info (if needed)
11. **Search** - If feature exists

---

## 📝 Implementation Notes

1. **Naming Conflict**: `NotificationItem` exists in both UI and API models
   - UI Model: `HeyPlay/Modules/Notification/Models/NotificationItem.swift`
   - API Model: Renamed to `APINotification` in `NotificationData.swift`

2. **Watch List Ambiguity**: Unclear if it's:
   - Watch Later (content saved for later)
   - Last Watch (watch history)
   - Favorites (liked content)
   - Check UI/requirements to determine

3. **Video Player**: Needs both:
   - Watch API (get streaming URL)
   - Last Watch API (track progress)

4. **All Services Created**: All API services exist and are ready to use
   - Just need to bind them to ViewModels
   - Follow existing patterns in HomeViewModel/HotViewModel
