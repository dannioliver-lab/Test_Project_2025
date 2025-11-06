import Foundation

// MARK: - User Model
struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let avatarURL: String?
    let role: String
    let department: String?
    let lastLoginAt: Date?
    let preferences: UserPreferences
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case avatarURL = "avatar_url"
        case role
        case department
        case lastLoginAt = "last_login_at"
        case preferences
    }
}

// MARK: - User Preferences
struct UserPreferences: Codable {
    let theme: String
    let notifications: Bool
    let language: String
    let timezone: String
    
    enum CodingKeys: String, CodingKey {
        case theme
        case notifications
        case language
        case timezone
    }
}
