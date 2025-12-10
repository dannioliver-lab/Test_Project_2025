import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    let displayName: String
    let username: String
    let email: String
    let avatarURL: String?
    let memberSince: Date
    
    init(id: UUID = UUID(), displayName: String, username: String, email: String, avatarURL: String? = nil, memberSince: Date = Date()) {
        self.id = id
        self.displayName = displayName
        self.username = username
        self.email = email
        self.avatarURL = avatarURL
        self.memberSince = memberSince
    }
}
