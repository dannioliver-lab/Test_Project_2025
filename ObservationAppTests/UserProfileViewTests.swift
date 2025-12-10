import XCTest
import SwiftUI
@testable import ObservationApp

class UserProfileViewTests: XCTestCase {
    
    var testUser: User!
    var testStatistics: UserStatistics!
    
    override func setUp() {
        super.setUp()
        testUser = User(
            displayName: "Test User",
            username: "testuser",
            email: "test@example.com",
            memberSince: Date()
        )
        
        let mockObservations = [
            Observation(title: "Test Observation", description: "Test", category: .flora, status: .verified, userID: testUser.id)
        ]
        
        testStatistics = UserStatistics(
            totalObservations: 10,
            recentActivity: mockObservations,
            categoryBreakdown: [.flora: 5, .fauna: 3, .weather: 2],
            currentStreak: 5,
            lastActiveDate: Date()
        )
    }
    
    override func tearDown() {
        testUser = nil
        testStatistics = nil
        super.tearDown()
    }
    
    func testUserModelInitialization() {
        XCTAssertEqual(testUser.displayName, "Test User")
        XCTAssertEqual(testUser.username, "testuser")
        XCTAssertEqual(testUser.email, "test@example.com")
        XCTAssertNotNil(testUser.id)
    }
    
    func testUserStatisticsInitialization() {
        XCTAssertEqual(testStatistics.totalObservations, 10)
        XCTAssertEqual(testStatistics.recentActivity.count, 1)
        XCTAssertEqual(testStatistics.categoryBreakdown[.flora], 5)
        XCTAssertEqual(testStatistics.currentStreak, 5)
        XCTAssertFalse(testStatistics.isEmpty)
    }
    
    func testEmptyUserStatistics() {
        let emptyStats = UserStatistics()
        XCTAssertTrue(emptyStats.isEmpty)
        XCTAssertEqual(emptyStats.totalObservations, 0)
        XCTAssertEqual(emptyStats.recentActivity.count, 0)
        XCTAssertEqual(emptyStats.currentStreak, 0)
    }
    
    func testObservationCategoryEnum() {
        XCTAssertEqual(ObservationCategory.flora.rawValue, "Flora")
        XCTAssertEqual(ObservationCategory.fauna.rawValue, "Fauna")
        XCTAssertEqual(ObservationCategory.weather.rawValue, "Weather")
        XCTAssertEqual(ObservationCategory.geology.rawValue, "Geology")
        XCTAssertEqual(ObservationCategory.other.rawValue, "Other")
        XCTAssertEqual(ObservationCategory.allCases.count, 5)
    }
    
    func testObservationStatusEnum() {
        XCTAssertEqual(ObservationStatus.pending.rawValue, "Pending")
        XCTAssertEqual(ObservationStatus.verified.rawValue, "Verified")
        XCTAssertEqual(ObservationStatus.rejected.rawValue, "Rejected")
        XCTAssertEqual(ObservationStatus.allCases.count, 3)
    }
    
    func testObservationInitialization() {
        let observation = Observation(
            title: "Test Observation",
            description: "Test Description",
            category: .flora,
            userID: testUser.id
        )
        
        XCTAssertEqual(observation.title, "Test Observation")
        XCTAssertEqual(observation.description, "Test Description")
        XCTAssertEqual(observation.category, .flora)
        XCTAssertEqual(observation.status, .pending) // Default status
        XCTAssertEqual(observation.userID, testUser.id)
        XCTAssertNotNil(observation.id)
    }
    
    func testUserStatsServiceMockData() {
        let service = UserStatsService()
        let mockStats = service.fetchMockUserStatistics(for: testUser.id)
        
        XCTAssertEqual(mockStats.totalObservations, 40)
        XCTAssertEqual(mockStats.recentActivity.count, 5)
        XCTAssertEqual(mockStats.currentStreak, 7)
        XCTAssertNotNil(mockStats.lastActiveDate)
        XCTAssertFalse(mockStats.isEmpty)
        
        // Test category breakdown
        let expectedTotal = mockStats.categoryBreakdown.values.reduce(0, +)
        XCTAssertEqual(expectedTotal, 40) // Should match totalObservations
    }
    
    func testUserStatsServiceAPIError() {
        let service = UserStatsService()
        
        // Test invalid URL error
        XCTAssertNotNil(UserStatsService.APIError.invalidURL)
        XCTAssertNotNil(UserStatsService.APIError.noData)
        XCTAssertNotNil(UserStatsService.APIError.decodingError)
    }
}

// MARK: - SwiftUI View Tests

class UserProfileViewUITests: XCTestCase {
    
    func testProfileHeaderViewCreation() {
        let user = User(
            displayName: "John Doe",
            username: "johndoe",
            email: "john@example.com"
        )
        
        let profileHeader = ProfileHeaderView(user: user)
        XCTAssertNotNil(profileHeader)
    }
    
    func testStatisticsDashboardViewCreation() {
        let statistics = UserStatistics(
            totalObservations: 25,
            recentActivity: [],
            categoryBreakdown: [.flora: 10, .fauna: 15],
            currentStreak: 3
        )
        
        let dashboard = StatisticsDashboardView(statistics: statistics)
        XCTAssertNotNil(dashboard)
    }
    
    func testEmptyStateViewCreation() {
        let emptyState = EmptyStateView()
        XCTAssertNotNil(emptyState)
    }
    
    func testLoadingStateViewCreation() {
        let loadingState = LoadingStateView()
        XCTAssertNotNil(loadingState)
    }
    
    func testErrorStateViewCreation() {
        let errorState = ErrorStateView(message: "Test error") {
            // Test retry action
        }
        XCTAssertNotNil(errorState)
    }
}

// MARK: - Performance Tests

class UserProfilePerformanceTests: XCTestCase {
    
    func testUserStatisticsPerformance() {
        let service = UserStatsService()
        let userID = UUID()
        
        measure {
            _ = service.fetchMockUserStatistics(for: userID)
        }
    }
    
    func testLargeObservationListPerformance() {
        let userID = UUID()
        var observations: [Observation] = []
        
        // Create 1000 mock observations
        for i in 0..<1000 {
            observations.append(Observation(
                title: "Observation \(i)",
                description: "Description \(i)",
                category: ObservationCategory.allCases.randomElement()!,
                userID: userID
            ))
        }
        
        measure {
            let statistics = UserStatistics(
                totalObservations: observations.count,
                recentActivity: Array(observations.prefix(5)),
                categoryBreakdown: [:],
                currentStreak: 10
            )
            XCTAssertEqual(statistics.totalObservations, 1000)
        }
    }
}
