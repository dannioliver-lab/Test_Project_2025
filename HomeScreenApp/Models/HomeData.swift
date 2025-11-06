import Foundation

// MARK: - Home Data Response Model
struct HomeData: Codable {
    let user: User
    let recentActivities: [Activity]
    let notifications: [Notification]
    let quickActions: [QuickAction]
    let stats: HomeStats
    
    enum CodingKeys: String, CodingKey {
        case user
        case recentActivities = "recent_activities"
        case notifications
        case quickActions = "quick_actions"
        case stats
    }
}

// MARK: - Home Stats
struct HomeStats: Codable {
    let totalTasks: Int
    let completedTasks: Int
    let pendingTasks: Int
    let upcomingDeadlines: Int
    
    enum CodingKeys: String, CodingKey {
        case totalTasks = "total_tasks"
        case completedTasks = "completed_tasks"
        case pendingTasks = "pending_tasks"
        case upcomingDeadlines = "upcoming_deadlines"
    }
}

// MARK: - Quick Action
struct QuickAction: Codable, Identifiable {
    let id: String
    let title: String
    let icon: String
    let action: String
    let isEnabled: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case icon
        case action
        case isEnabled = "is_enabled"
    }
}

// MARK: - Notification
struct Notification: Codable, Identifiable {
    let id: String
    let title: String
    let message: String
    let type: NotificationType
    let timestamp: Date
    let isRead: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case message
        case type
        case timestamp
        case isRead = "is_read"
    }
}

enum NotificationType: String, Codable, CaseIterable {
    case info = "info"
    case warning = "warning"
    case error = "error"
    case success = "success"
}
