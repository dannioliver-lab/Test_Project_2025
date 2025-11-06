import XCTest
@testable import HomeScreenApp

final class NetworkServiceTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    
    override func setUpWithError() throws {
        mockNetworkService = MockNetworkService()
    }
    
    override func tearDownWithError() throws {
        mockNetworkService = nil
    }
    
    func testFetchHomeDataSuccess() async throws {
        // When
        let homeData = try await mockNetworkService.fetchHomeData()
        
        // Then
        XCTAssertNotNil(homeData)
        XCTAssertEqual(homeData.user.name, "John Doe")
        XCTAssertEqual(homeData.user.email, "john.doe@example.com")
        XCTAssertEqual(homeData.stats.totalTasks, 25)
        XCTAssertEqual(homeData.stats.completedTasks, 18)
        XCTAssertEqual(homeData.recentActivities.count, 2)
        XCTAssertEqual(homeData.notifications.count, 1)
        XCTAssertEqual(homeData.quickActions.count, 2)
    }
    
    func testFetchUserProfileSuccess() async throws {
        // Given
        let userId = "test-user-id"
        
        // When
        let user = try await mockNetworkService.fetchUserProfile(userId: userId)
        
        // Then
        XCTAssertNotNil(user)
        XCTAssertEqual(user.id, userId)
        XCTAssertEqual(user.name, "John Doe")
        XCTAssertEqual(user.email, "john.doe@example.com")
        XCTAssertEqual(user.role, "Developer")
        XCTAssertEqual(user.department, "Engineering")
    }
    
    func testHomeDataStructure() async throws {
        // When
        let homeData = try await mockNetworkService.fetchHomeData()
        
        // Then - Verify data structure
        XCTAssertNotNil(homeData.user)
        XCTAssertNotNil(homeData.stats)
        XCTAssertFalse(homeData.recentActivities.isEmpty)
        XCTAssertFalse(homeData.notifications.isEmpty)
        XCTAssertFalse(homeData.quickActions.isEmpty)
        
        // Verify user preferences
        XCTAssertNotNil(homeData.user.preferences)
        XCTAssertEqual(homeData.user.preferences.theme, "dark")
        XCTAssertTrue(homeData.user.preferences.notifications)
        
        // Verify quick actions are enabled
        for action in homeData.quickActions {
            XCTAssertTrue(action.isEnabled)
            XCTAssertFalse(action.title.isEmpty)
            XCTAssertFalse(action.icon.isEmpty)
        }
        
        // Verify activities have required fields
        for activity in homeData.recentActivities {
            XCTAssertFalse(activity.title.isEmpty)
            XCTAssertFalse(activity.description.isEmpty)
            XCTAssertNotNil(activity.timestamp)
        }
    }
    
    func testNetworkServiceProtocolConformance() {
        // Given
        let networkService: NetworkServiceProtocol = NetworkService()
        let mockService: NetworkServiceProtocol = MockNetworkService()
        
        // Then - Both services should conform to the protocol
        XCTAssertTrue(networkService is NetworkServiceProtocol)
        XCTAssertTrue(mockService is NetworkServiceProtocol)
    }
}
