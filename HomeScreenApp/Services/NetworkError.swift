import Foundation

// MARK: - Network Error
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case serverError(Int)
    case unauthorized
    case forbidden
    case notFound
    case timeout
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .unauthorized:
            return "Unauthorized access"
        case .forbidden:
            return "Access forbidden"
        case .notFound:
            return "Resource not found"
        case .timeout:
            return "Request timeout"
        case .unknown:
            return "Unknown error occurred"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .unauthorized:
            return "Please check your authentication credentials"
        case .networkError:
            return "Please check your internet connection"
        case .serverError:
            return "Please try again later"
        case .timeout:
            return "Please check your connection and try again"
        default:
            return "Please try again"
        }
    }
}
