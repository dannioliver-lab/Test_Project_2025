import Foundation

// MARK: - API Endpoints
enum APIEndpoints {
    case home
    case userProfile(String)
    case activities
    case notifications
    
    var path: String {
        switch self {
        case .home:
            return "/api/v2/home"
        case .userProfile(let userId):
            return "/api/v2/users/\(userId)"
        case .activities:
            return "/api/v2/activities"
        case .notifications:
            return "/api/v2/notifications"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .home, .userProfile, .activities, .notifications:
            return .GET
        }
    }
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// MARK: - API Configuration
struct APIConfiguration {
    static let baseURL = "https://api.example.com" // This should be configurable
    static let timeout: TimeInterval = 30.0
    static let defaultHeaders: [String: String] = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
}
