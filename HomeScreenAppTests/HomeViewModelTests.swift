import XCTest
@testable import HomeScreenApp

@MainActor
final class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var mockNetworkService: MockNetworkService!
    
    override func setUpWithError() throws {
        mockNetworkService = MockNetworkService()
        viewModel = HomeViewModel(networkService: mockNetworkService)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockNetworkService = nil
    }
    
    func testInitialState() {
        // Then
        XCTAssertNil(viewModel.homeData)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
        XCTAssertFalse(viewModel.hasData)
    }
    
    func testLoadHomeDataSuccess() async {
        // When
        await viewModel.loadHomeData()
        
        // Then
        XCTAssertNotNil(viewModel.homeData)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
        XCTAssertTrue(viewModel.hasData)
        
        // Verify data content
        XCTAssertEqual(viewModel.homeData?.user.name, "John Doe")
        XCTAssertEqual(viewModel.homeData?.stats.totalTasks, 25)
        XCTAssertEqual(viewModel.homeData?.stats.completedTasks, 18)
    }
    
    func testCompletionPercentage() async {
        // When
        await viewModel.loadHomeData()
        
        // Then
        let expectedPercentage = 18.0 / 25.0 // completedTasks / totalTasks
        XCTAssertEqual(viewModel.completionPercentage, expectedPercentage, accuracy: 0.001)
    }
    
    func testCompletionPercentageWithZeroTasks() {
        // Given - Create a custom home data with zero tasks
        let homeData = HomeData(
            user: User(
                id: "1",
                name: "Test User",
                email: "test@example.com",
                avatarURL: nil,
                role: "Tester",
                department: nil,
                lastLoginAt: nil,
                preferences: UserPreferences(theme: "light", notifications: true, language: "en", timezone: "UTC")
            ),
            recentActivities: [],
            notifications: [],
            quickActions: [],
            stats: HomeStats(totalTasks: 0, completedTasks: 0, pendingTasks: 0, upcomingDeadlines: 0)
        )
        
        // When
        viewModel.homeData = homeData
        
        // Then
        XCTAssertEqual(viewModel.completionPercentage, 0.0)
    }
    
    func testUnreadNotificationsCount() async {
        // When
        await viewModel.loadHomeData()
        
        // Then
        XCTAssertEqual(viewModel.unreadNotificationsCount, 1) // Mock data has 1 unread notification
    }
    
    func testRecentActivitiesCount() async {
        // When
        await viewModel.loadHomeData()
        
        // Then
        XCTAssertEqual(viewModel.recentActivitiesCount, 2) // Mock data has 2 activities
    }
    
    func testRefreshData() async {
        // Given - Load initial data
        await viewModel.loadHomeData()
        let initialData = viewModel.homeData
        
        // When
        await viewModel.refreshData()
        
        // Then
        XCTAssertNotNil(viewModel.homeData)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.homeData?.user.name, initialData?.user.name)
    }
    
    func testDismissError() {
        // Given
        viewModel.errorMessage = "Test error"
        viewModel.showError = true
        
        // When
        viewModel.dismissError()
        
        // Then
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testHandleQuickAction() async {
        // Given
        await viewModel.loadHomeData()
        guard let quickAction = viewModel.homeData?.quickActions.first else {
            XCTFail("No quick actions available")
            return
        }
        
        // When - This should not crash and should handle the action
        viewModel.handleQuickAction(quickAction)
        
        // Then - No assertions needed as this is mainly for navigation/side effects
        // In a real app, you might test navigation or state changes
        XCTAssertTrue(true) // Test passes if no crash occurs
    }
    
    func testMarkNotificationAsRead() async {
        // Given
        await viewModel.loadHomeData()
        guard let notification = viewModel.homeData?.notifications.first else {
            XCTFail("No notifications available")
            return
        }
        
        // When
        viewModel.markNotificationAsRead(notification)
        
        // Then - In the current implementation, this just prints
        // In a real app, you would test the API call or state change
        XCTAssertTrue(true) // Test passes if no crash occurs
    }
    
    func testViewAllActivities() {
        // When
        viewModel.viewAllActivities()
        
        // Then - This should not crash
        XCTAssertTrue(true)
    }
    
    func testViewAllNotifications() {
        // When
        viewModel.viewAllNotifications()
        
        // Then - This should not crash
        XCTAssertTrue(true)
    }
    
    func testPreviewViewModel() {
        // Given
        let previewViewModel = HomeViewModel.preview
        
        // Then
        XCTAssertNotNil(previewViewModel)
        XCTAssertTrue(previewViewModel.networkService is MockNetworkService)
    }
}
