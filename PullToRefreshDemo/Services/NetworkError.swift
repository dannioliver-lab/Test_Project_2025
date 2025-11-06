import Foundation

/// Represents different types of network and data loading errors
enum NetworkError: Error {
    case noInternetConnection
    case serverError(Int)
    case timeout
    case invalidData
    case unknown(Error)
    
    /// User-friendly error message for display
    var localizedDescription: String {
        switch self {
        case .noInternetConnection:
            return "No internet connection. Please check your network and try again."
        case .serverError(let code):
            return "Server error (\(code)). Please try again later."
        case .timeout:
            return "Request timed out. Please check your connection and try again."
        case .invalidData:
            return "Invalid data received. Please try again."
        case .unknown(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    /// Short title for error alerts
    var title: String {
        switch self {
        case .noInternetConnection:
            return "No Internet"
        case .serverError:
            return "Server Error"
        case .timeout:
            return "Connection Timeout"
        case .invalidData:
            return "Data Error"
        case .unknown:
            return "Error"
        }
    }
}

// MARK: - Equatable
extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.noInternetConnection, .noInternetConnection),
             (.timeout, .timeout),
             (.invalidData, .invalidData):
            return true
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode
        case (.unknown(let lhsError), .unknown(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
