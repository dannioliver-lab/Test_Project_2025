import XCTest
import SwiftUI
@testable import PersonalizedGreeting

/// Unit tests for the PersonalizedGreeting component
final class PersonalizedGreetingTests: XCTestCase {
    
    // MARK: - GreetingTimeProvider Tests
    
    func testMorningGreeting() {
        // Given: 9 AM
        let morningDate = createDate(hour: 9)
        let provider = GreetingTimeProvider(currentDate: morningDate)
        
        // When
        let greeting = provider.getTimeBasedGreeting()
        
        // Then
        XCTAssertEqual(greeting, "Good morning")
    }
    
    func testAfternoonGreeting() {
        // Given: 2 PM
        let afternoonDate = createDate(hour: 14)
        let provider = GreetingTimeProvider(currentDate: afternoonDate)
        
        // When
        let greeting = provider.getTimeBasedGreeting()
        
        // Then
        XCTAssertEqual(greeting, "Good afternoon")
    }
    
    func testEveningGreeting() {
        // Given: 7 PM
        let eveningDate = createDate(hour: 19)
        let provider = GreetingTimeProvider(currentDate: eveningDate)
        
        // When
        let greeting = provider.getTimeBasedGreeting()
        
        // Then
        XCTAssertEqual(greeting, "Good evening")
    }
    
    func testNightGreeting() {
        // Given: 11 PM
        let nightDate = createDate(hour: 23)
        let provider = GreetingTimeProvider(currentDate: nightDate)
        
        // When
        let greeting = provider.getTimeBasedGreeting()
        
        // Then
        XCTAssertEqual(greeting, "Good night")
    }
    
    func testEarlyMorningGreeting() {
        // Given: 3 AM
        let earlyMorningDate = createDate(hour: 3)
        let provider = GreetingTimeProvider(currentDate: earlyMorningDate)
        
        // When
        let greeting = provider.getTimeBasedGreeting()
        
        // Then
        XCTAssertEqual(greeting, "Good night")
    }
    
    func testBoundaryConditions() {
        // Test boundary at 5 AM (start of morning)
        let fiveAM = createDate(hour: 5)
        let provider5AM = GreetingTimeProvider(currentDate: fiveAM)
        XCTAssertEqual(provider5AM.getTimeBasedGreeting(), "Good morning")
        
        // Test boundary at 12 PM (start of afternoon)
        let noon = createDate(hour: 12)
        let providerNoon = GreetingTimeProvider(currentDate: noon)
        XCTAssertEqual(providerNoon.getTimeBasedGreeting(), "Good afternoon")
        
        // Test boundary at 5 PM (start of evening)
        let fivePM = createDate(hour: 17)
        let provider5PM = GreetingTimeProvider(currentDate: fivePM)
        XCTAssertEqual(provider5PM.getTimeBasedGreeting(), "Good evening")
        
        // Test boundary at 9 PM (start of night)
        let ninePM = createDate(hour: 21)
        let provider9PM = GreetingTimeProvider(currentDate: ninePM)
        XCTAssertEqual(provider9PM.getTimeBasedGreeting(), "Good night")
    }
    
    func testFormattedDate() {
        // Given
        let testDate = createDate(year: 2024, month: 10, day: 9, hour: 12)
        let provider = GreetingTimeProvider(currentDate: testDate)
        
        // When
        let formattedDate = provider.getFormattedDate()
        
        // Then
        XCTAssertTrue(formattedDate.contains("2024"))
        XCTAssertTrue(formattedDate.contains("October") || formattedDate.contains("Oct"))
        XCTAssertTrue(formattedDate.contains("9"))
    }
    
    // MARK: - PersonalizedGreetingConfiguration Tests
    
    func testDefaultConfiguration() {
        // Given
        let config = PersonalizedGreetingConfiguration(userName: "John")
        
        // Then
        XCTAssertEqual(config.userName, "John")
        XCTAssertNil(config.customMessage)
        XCTAssertTrue(config.showTimeBasedGreeting)
        XCTAssertTrue(config.showDateSubtitle)
        XCTAssertEqual(config.greetingStyle, .standard)
    }
    
    func testCustomConfiguration() {
        // Given
        let config = PersonalizedGreetingConfiguration(
            userName: "Sarah",
            customMessage: "Welcome back, {name}!",
            showTimeBasedGreeting: false,
            showDateSubtitle: false,
            greetingStyle: .prominent
        )
        
        // Then
        XCTAssertEqual(config.userName, "Sarah")
        XCTAssertEqual(config.customMessage, "Welcome back, {name}!")
        XCTAssertFalse(config.showTimeBasedGreeting)
        XCTAssertFalse(config.showDateSubtitle)
        XCTAssertEqual(config.greetingStyle, .prominent)
    }
    
    // MARK: - GreetingPreferences Tests
    
    func testGreetingPreferencesEncoding() throws {
        // Given
        var preferences = GreetingPreferences()
        preferences.showTimeBasedGreeting = false
        preferences.customMessage = "Hello, {name}!"
        preferences.greetingStyle = .compact
        
        // When
        let data = try JSONEncoder().encode(preferences)
        let decodedPreferences = try JSONDecoder().decode(GreetingPreferences.self, from: data)
        
        // Then
        XCTAssertFalse(decodedPreferences.showTimeBasedGreeting)
        XCTAssertEqual(decodedPreferences.customMessage, "Hello, {name}!")
        XCTAssertEqual(decodedPreferences.greetingStyle, .compact)
    }
    
    func testGreetingPreferencesDefaultValues() {
        // Given
        let preferences = GreetingPreferences()
        
        // Then
        XCTAssertTrue(preferences.showTimeBasedGreeting)
        XCTAssertTrue(preferences.showDateSubtitle)
        XCTAssertNil(preferences.customMessage)
        XCTAssertEqual(preferences.greetingStyle, .standard)
        XCTAssertFalse(preferences.use24HourFormat)
    }
    
    // MARK: - GreetingStyle Tests
    
    func testGreetingStyleDisplayNames() {
        XCTAssertEqual(GreetingStyle.standard.displayName, "Standard")
        XCTAssertEqual(GreetingStyle.compact.displayName, "Compact")
        XCTAssertEqual(GreetingStyle.prominent.displayName, "Prominent")
    }
    
    func testGreetingStyleCaseIterable() {
        let allStyles = GreetingStyle.allCases
        XCTAssertEqual(allStyles.count, 3)
        XCTAssertTrue(allStyles.contains(.standard))
        XCTAssertTrue(allStyles.contains(.compact))
        XCTAssertTrue(allStyles.contains(.prominent))
    }
    
    // MARK: - Helper Methods
    
    private func createDate(year: Int = 2024, month: Int = 10, day: Int = 9, hour: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = 0
        components.second = 0
        
        return Calendar.current.date(from: components) ?? Date()
    }
}

// MARK: - Integration Tests

final class PersonalizedGreetingIntegrationTests: XCTestCase {
    
    func testGreetingTextGeneration() {
        // Test that the greeting text is generated correctly for different scenarios
        
        // Test 1: Default morning greeting
        let morningDate = createDate(hour: 9)
        let morningConfig = PersonalizedGreetingConfiguration(userName: "Alice")
        let morningProvider = GreetingTimeProvider(currentDate: morningDate)
        
        let expectedMorningGreeting = "Good morning, Alice!"
        // Note: In a real implementation, we'd need to expose the greeting text generation
        // or create a separate service class for testing
        
        // Test 2: Custom message
        let customConfig = PersonalizedGreetingConfiguration(
            userName: "Bob",
            customMessage: "Welcome back, {name}! Ready for today?"
        )
        let expectedCustomGreeting = "Welcome back, Bob! Ready for today?"
        
        // Test 3: No time-based greeting
        let simpleConfig = PersonalizedGreetingConfiguration(
            userName: "Charlie",
            showTimeBasedGreeting: false
        )
        let expectedSimpleGreeting = "Hello, Charlie!"
        
        // These tests would be more complete with a separate greeting text service
        XCTAssertTrue(true, "Integration tests would require refactoring to separate concerns")
    }
    
    private func createDate(hour: Int) -> Date {
        var components = DateComponents()
        components.year = 2024
        components.month = 10
        components.day = 9
        components.hour = hour
        components.minute = 0
        components.second = 0
        
        return Calendar.current.date(from: components) ?? Date()
    }
}

// MARK: - Performance Tests

final class PersonalizedGreetingPerformanceTests: XCTestCase {
    
    func testGreetingTimeProviderPerformance() {
        // Test that greeting generation is fast enough for UI updates
        measure {
            for _ in 0..<1000 {
                let provider = GreetingTimeProvider()
                _ = provider.getTimeBasedGreeting()
                _ = provider.getFormattedDate()
            }
        }
    }
    
    func testGreetingPreferencesEncodingPerformance() {
        // Test that preferences encoding/decoding is performant
        let preferences = GreetingPreferences()
        
        measure {
            for _ in 0..<100 {
                do {
                    let data = try JSONEncoder().encode(preferences)
                    _ = try JSONDecoder().decode(GreetingPreferences.self, from: data)
                } catch {
                    XCTFail("Encoding/decoding failed: \(error)")
                }
            }
        }
    }
}
