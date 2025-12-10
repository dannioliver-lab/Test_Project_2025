import Foundation
import Combine

class UserStatsService: ObservableObject {
    private let baseURL = "https://api.example.com/v1"
    
    enum APIError: Error {
        case invalidURL
        case noData
        case decodingError
        case networkError(Error)
    }
    
    func fetchUserStatistics(for userID: UUID) -> AnyPublisher<UserStatistics, APIError> {
        guard let url = URL(string: "\(baseURL)/user/\(userID.uuidString)/stats") else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: UserStatistics.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return APIError.decodingError
                } else {
                    return APIError.networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // Mock data for development/testing
    func fetchMockUserStatistics(for userID: UUID) -> UserStatistics {
        let mockObservations = [
            Observation(title: "Red Cardinal", description: "Beautiful red cardinal spotted in oak tree", category: .fauna, status: .verified, createdAt: Date().addingTimeInterval(-86400), userID: userID),
            Observation(title: "Morning Frost", description: "Heavy frost on grass this morning", category: .weather, status: .pending, createdAt: Date().addingTimeInterval(-172800), userID: userID),
            Observation(title: "Wild Roses", description: "Pink wild roses blooming along trail", category: .flora, status: .verified, createdAt: Date().addingTimeInterval(-259200), userID: userID),
            Observation(title: "Thunder Storm", description: "Intense thunderstorm with heavy rain", category: .weather, status: .verified, createdAt: Date().addingTimeInterval(-345600), userID: userID),
            Observation(title: "Monarch Butterfly", description: "Monarch butterfly on milkweed", category: .fauna, status: .pending, createdAt: Date().addingTimeInterval(-432000), userID: userID)
        ]
        
        let categoryBreakdown: [ObservationCategory: Int] = [
            .fauna: 15,
            .flora: 12,
            .weather: 8,
            .geology: 3,
            .other: 2
        ]
        
        return UserStatistics(
            totalObservations: 40,
            recentActivity: Array(mockObservations.prefix(5)),
            categoryBreakdown: categoryBreakdown,
            currentStreak: 7,
            lastActiveDate: Date()
        )
    }
}
