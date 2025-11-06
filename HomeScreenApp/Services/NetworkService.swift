import Foundation

// MARK: - Network Service Protocol
protocol NetworkServiceProtocol {
    func fetchHomeData() async throws -> HomeData
    func fetchUserProfile(userId: String) async throws -> User
}

// MARK: - Network Service
class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        
        // Configure date decoding strategy
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(formatter)
    }
    
    // MARK: - Public Methods
    
    func fetchHomeData() async throws -> HomeData {
        return try await performRequest(endpoint: .home, responseType: HomeData.self)
    }
    
    func fetchUserProfile(userId: String) async throws -> User {
        return try await performRequest(endpoint: .userProfile(userId), responseType: User.self)
    }
    
    // MARK: - Private Methods
    
    private func performRequest<T: Codable>(
        endpoint: APIEndpoints,
        responseType: T.Type
    ) async throws -> T {
        let request = try buildRequest(for: endpoint)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            try validateResponse(httpResponse)
            
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            do {
                let decodedResponse = try decoder.decode(responseType, from: data)
                return decodedResponse
            } catch {
                throw NetworkError.decodingError(error)
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    private func buildRequest(for endpoint: APIEndpoints) throws -> URLRequest {
        guard let url = URL(string: APIConfiguration.baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = APIConfiguration.timeout
        
        // Add default headers
        for (key, value) in APIConfiguration.defaultHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add authentication header if available
        if let authToken = getAuthToken() {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    private func validateResponse(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...299:
            return
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 408:
            throw NetworkError.timeout
        case 500...599:
            throw NetworkError.serverError(response.statusCode)
        default:
            throw NetworkError.unknown
        }
    }
    
    private func getAuthToken() -> String? {
        // In a real app, this would retrieve the token from keychain or user defaults
        // For now, return nil to indicate no authentication
        return nil
    }
}

// MARK: - Mock Network Service (for testing/preview)
class MockNetworkService: NetworkServiceProtocol {
    func fetchHomeData() async throws -> HomeData {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        return HomeData(
            user: User(
                id: "1",
                name: "John Doe",
                email: "john.doe@example.com",
                avatarURL: "https://example.com/avatar.jpg",
                role: "Developer",
                department: "Engineering",
                lastLoginAt: Date(),
                preferences: UserPreferences(
                    theme: "dark",
                    notifications: true,
                    language: "en",
                    timezone: "UTC"
                )
            ),
            recentActivities: [
                Activity(
                    id: "1",
                    title: "Task Completed",
                    description: "Completed the home screen integration task",
                    type: .taskCompleted,
                    timestamp: Date(),
                    status: .completed,
                    metadata: nil
                ),
                Activity(
                    id: "2",
                    title: "New Project Created",
                    description: "Created a new mobile app project",
                    type: .projectCreated,
                    timestamp: Date().addingTimeInterval(-3600),
                    status: .completed,
                    metadata: nil
                )
            ],
            notifications: [
                Notification(
                    id: "1",
                    title: "Welcome!",
                    message: "Welcome to the new home screen",
                    type: .info,
                    timestamp: Date(),
                    isRead: false
                )
            ],
            quickActions: [
                QuickAction(
                    id: "1",
                    title: "Create Task",
                    icon: "plus.circle",
                    action: "create_task",
                    isEnabled: true
                ),
                QuickAction(
                    id: "2",
                    title: "View Reports",
                    icon: "chart.bar",
                    action: "view_reports",
                    isEnabled: true
                )
            ],
            stats: HomeStats(
                totalTasks: 25,
                completedTasks: 18,
                pendingTasks: 7,
                upcomingDeadlines: 3
            )
        )
    }
    
    func fetchUserProfile(userId: String) async throws -> User {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        return User(
            id: userId,
            name: "John Doe",
            email: "john.doe@example.com",
            avatarURL: "https://example.com/avatar.jpg",
            role: "Developer",
            department: "Engineering",
            lastLoginAt: Date(),
            preferences: UserPreferences(
                theme: "dark",
                notifications: true,
                language: "en",
                timezone: "UTC"
            )
        )
    }
}
