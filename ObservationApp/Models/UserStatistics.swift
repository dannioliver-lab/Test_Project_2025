import Foundation

struct UserStatistics: Codable {
    let totalObservations: Int
    let recentActivity: [Observation]
    let categoryBreakdown: [ObservationCategory: Int]
    let currentStreak: Int
    let lastActiveDate: Date?
    
    init(totalObservations: Int = 0, recentActivity: [Observation] = [], categoryBreakdown: [ObservationCategory: Int] = [:], currentStreak: Int = 0, lastActiveDate: Date? = nil) {
        self.totalObservations = totalObservations
        self.recentActivity = recentActivity
        self.categoryBreakdown = categoryBreakdown
        self.currentStreak = currentStreak
        self.lastActiveDate = lastActiveDate
    }
    
    var isEmpty: Bool {
        return totalObservations == 0
    }
}
