import Foundation

// MARK: - App Configuration
struct AppConfig {
    // MARK: - API Configuration
    struct API {
        static let baseURL: String = {
            #if DEBUG
            return "https://api-dev.example.com"
            #else
            return "https://api.example.com"
            #endif
        }()
        
        static let timeout: TimeInterval = 30.0
        static let retryCount = 3
        static let retryDelay: TimeInterval = 1.0
    }
    
    // MARK: - App Information
    struct App {
        static let name = "Home Screen"
        static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        static let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        static let bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.example.homescreen"
    }
    
    // MARK: - Feature Flags
    struct Features {
        static let enableMockData = false
        static let enableDebugLogging = true
        static let enableAnalytics = false
        static let enablePushNotifications = true
    }
    
    // MARK: - UI Configuration
    struct UI {
        static let animationDuration: TimeInterval = 0.3
        static let cornerRadius: CGFloat = 12.0
        static let shadowRadius: CGFloat = 2.0
        static let shadowOpacity: Float = 0.1
    }
    
    // MARK: - Cache Configuration
    struct Cache {
        static let homeDataCacheKey = "home_data_cache"
        static let cacheExpirationTime: TimeInterval = 300 // 5 minutes
        static let maxCacheSize = 50 * 1024 * 1024 // 50MB
    }
}

// MARK: - Environment Detection
extension AppConfig {
    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    static var isTestFlight: Bool {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
            return false
        }
        return appStoreReceiptURL.lastPathComponent == "sandboxReceipt"
    }
}
