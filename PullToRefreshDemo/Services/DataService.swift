import Foundation

/// Service responsible for fetching list data
class DataService {
    
    static let shared = DataService()
    
    private init() {}
    
    /// Simulates fetching initial data
    /// - Parameter completion: Completion handler with result containing list items or error
    func fetchInitialData(completion: @escaping (Result<[ListItem], NetworkError>) -> Void) {
        // Simulate network delay
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1.0) {
            DispatchQueue.main.async {
                // Simulate occasional network errors (10% chance)
                if Int.random(in: 1...10) == 1 {
                    completion(.failure(.noInternetConnection))
                    return
                }
                
                let data = ListItem.sampleData()
                completion(.success(data))
            }
        }
    }
    
    /// Simulates refreshing data (pull-to-refresh)
    /// - Parameter completion: Completion handler with result containing updated list items or error
    func refreshData(completion: @escaping (Result<[ListItem], NetworkError>) -> Void) {
        // Simulate network delay for refresh
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2.0) {
            DispatchQueue.main.async {
                // Simulate different types of errors occasionally
                let errorChance = Int.random(in: 1...20)
                
                switch errorChance {
                case 1:
                    completion(.failure(.noInternetConnection))
                    return
                case 2:
                    completion(.failure(.serverError(500)))
                    return
                case 3:
                    completion(.failure(.timeout))
                    return
                default:
                    break
                }
                
                // Return fresh data
                let newData = ListItem.newSampleData()
                completion(.success(newData))
            }
        }
    }
    
    /// Simulates loading more data (pagination)
    /// - Parameters:
    ///   - currentItems: Current items in the list
    ///   - completion: Completion handler with result containing additional items or error
    func loadMoreData(currentItems: [ListItem], completion: @escaping (Result<[ListItem], NetworkError>) -> Void) {
        // Simulate network delay
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1.5) {
            DispatchQueue.main.async {
                // Simulate occasional errors
                if Int.random(in: 1...15) == 1 {
                    completion(.failure(.serverError(503)))
                    return
                }
                
                // Generate additional items
                let additionalItems = (0..<5).map { index in
                    ListItem(
                        title: "Additional Item \(currentItems.count + index + 1)",
                        subtitle: "Loaded via pagination"
                    )
                }
                
                completion(.success(additionalItems))
            }
        }
    }
}

// MARK: - Mock Data Helpers
extension DataService {
    
    /// Simulates a successful refresh with predefined data
    func mockSuccessfulRefresh(completion: @escaping (Result<[ListItem], NetworkError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let mockData = [
                ListItem(title: "Fresh Content", subtitle: "Just updated"),
                ListItem(title: "New Article", subtitle: "Published moments ago"),
                ListItem(title: "Latest Update", subtitle: "Hot off the press")
            ]
            completion(.success(mockData))
        }
    }
    
    /// Simulates a failed refresh for testing error handling
    func mockFailedRefresh(with error: NetworkError, completion: @escaping (Result<[ListItem], NetworkError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.failure(error))
        }
    }
}
