import Foundation

class ContentService {
    static let shared = ContentService()
    
    private init() {}
    
    /// Simulates fetching initial content
    func loadInitialContent() async -> [ContentItem] {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return ContentItem.sampleData()
    }
    
    /// Simulates refreshing content with new data
    func refreshContent() async throws -> [ContentItem] {
        // Simulate network delay for refresh
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        // Simulate potential network error (10% chance)
        if Int.random(in: 1...10) == 1 {
            throw ContentServiceError.networkError
        }
        
        return ContentItem.refreshedData()
    }
}

// MARK: - Content Service Errors
enum ContentServiceError: Error, LocalizedError {
    case networkError
    case invalidData
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network connection failed. Please check your internet connection and try again."
        case .invalidData:
            return "Invalid data received from server."
        case .timeout:
            return "Request timed out. Please try again."
        }
    }
}
