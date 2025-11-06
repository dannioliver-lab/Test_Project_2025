import Foundation
import SwiftUI

// MARK: - Home View Model
@MainActor
class HomeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var homeData: HomeData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    // MARK: - Private Properties
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Computed Properties
    var hasData: Bool {
        homeData != nil
    }
    
    var completionPercentage: Double {
        guard let stats = homeData?.stats else { return 0.0 }
        guard stats.totalTasks > 0 else { return 0.0 }
        return Double(stats.completedTasks) / Double(stats.totalTasks)
    }
    
    var unreadNotificationsCount: Int {
        homeData?.notifications.filter { !$0.isRead }.count ?? 0
    }
    
    var recentActivitiesCount: Int {
        homeData?.recentActivities.count ?? 0
    }
    
    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    
    func loadHomeData() async {
        isLoading = true
        errorMessage = nil
        showError = false
        
        do {
            let data = try await networkService.fetchHomeData()
            homeData = data
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    func refreshData() async {
        await loadHomeData()
    }
    
    func dismissError() {
        showError = false
        errorMessage = nil
    }
    
    func handleQuickAction(_ action: QuickAction) {
        // Handle quick action tap
        print("Quick action tapped: \(action.action)")
        
        // In a real app, this would navigate to the appropriate screen
        // or perform the requested action
        switch action.action {
        case "create_task":
            // Navigate to task creation screen
            break
        case "view_reports":
            // Navigate to reports screen
            break
        default:
            print("Unknown action: \(action.action)")
        }
    }
    
    func markNotificationAsRead(_ notification: Notification) {
        // In a real app, this would make an API call to mark the notification as read
        // For now, we'll just update the local state
        guard let index = homeData?.notifications.firstIndex(where: { $0.id == notification.id }) else {
            return
        }
        
        // Note: Since our models are immutable, we'd need to create a new notification
        // and update the entire homeData. In a real app, you might want to make
        // notifications mutable or handle this differently.
        print("Marking notification as read: \(notification.id)")
    }
    
    func viewAllActivities() {
        // Navigate to activities screen
        print("View all activities tapped")
    }
    
    func viewAllNotifications() {
        // Navigate to notifications screen
        print("View all notifications tapped")
    }
    
    // MARK: - Private Methods
    
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            errorMessage = networkError.localizedDescription
        } else {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
        showError = true
    }
}

// MARK: - Preview Helper
extension HomeViewModel {
    static var preview: HomeViewModel {
        let viewModel = HomeViewModel(networkService: MockNetworkService())
        return viewModel
    }
}
