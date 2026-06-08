//
//  VIPHistoryViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import Foundation
import Combine
import UIKit

final class VIPHistoryViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var histories: [PackageHistory] = []

    // Date filters
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var showStartDatePicker: Bool = false
    @Published var showEndDatePicker: Bool = false

    // MARK: - Computed Properties
    var hasHistories: Bool {
        return !histories.isEmpty
    }

    var startDateString: String {
        return formatDate(startDate)
    }

    var endDateString: String {
        return formatDate(endDate)
    }

    // Date range for pickers
    var maxDate: Date {
        return Date() // Today is the maximum selectable date
    }

    var endDateMinimum: Date {
        return startDate // End date must be >= start date
    }

    // MARK: - Init
    init() {
        // Set default date range (e.g., last 30 days to today)
        let calendar = Calendar.current
        if let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: Date()) {
            startDate = thirtyDaysAgo
        }
        endDate = Date()
    }

    // MARK: - Fetch History
    func fetchHistory() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        print("📋 [VIPHistoryViewModel] Fetching history from \(startDateString) to \(endDateString)")

        // Format dates for API (dd/MM/yyyy)
        let fromDate = formatDateForAPI(startDate)
        let toDate = formatDateForAPI(endDate)

        let result = await SubscriptionPlanService.shared.getPackageHistory(
            fromDate: fromDate,
            toDate: toDate
        )

        await MainActor.run {
            isLoading = false

            switch result {
            case .success(let histories):
                self.histories = histories
                print("✅ [VIPHistoryViewModel] Loaded \(histories.count) history records")

            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("❌ [VIPHistoryViewModel] Error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Date Formatting
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func formatDateForAPI(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }

    // MARK: - Date Selection
    func selectStartDate(_ date: Date) {
        startDate = date

        // If end date is now before start date, adjust it to match start date
        if endDate < startDate {
            endDate = startDate
        }

        showStartDatePicker = false
    }

    func selectEndDate(_ date: Date) {
        endDate = date
        showEndDatePicker = false
    }

    // MARK: - Date Validation
    func validateDates() {
        // Ensure start date is not in the future
        if startDate > Date() {
            startDate = Date()
        }

        // Ensure end date is not in the future
        if endDate > Date() {
            endDate = Date()
        }

        // Ensure end date is not before start date
        if endDate < startDate {
            endDate = startDate
        }
    }

    // MARK: - Search
    func search() {
        // Validate dates before searching
        validateDates()

        Task {
            await fetchHistory()
        }
    }
}
