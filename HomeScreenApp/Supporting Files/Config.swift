import Foundation

struct AppConfig {
    // MARK: - App Information
    static let appName = "Home Screen"
    static let version = "1.0.0"
    static let buildNumber = "1"
    
    // MARK: - Widget Configuration
    static let maxWidgetsPerScreen = 10
    static let defaultRefreshInterval: TimeInterval = 300 // 5 minutes
    static let animationDuration: Double = 0.3
    
    // MARK: - Layout Configuration
    static let defaultLayoutConfiguration = LayoutConfiguration.standard
    static let supportedOrientations: [UIInterfaceOrientation] = [.portrait, .landscapeLeft, .landscapeRight]
    
    // MARK: - Feature Flags
    struct FeatureFlags {
        static let enableWidgetReordering = true
        static let enableCustomWidgets = false
        static let enableDarkModeSupport = true
        static let enableAccessibilityFeatures = true
    }
    
    // MARK: - API Configuration
    struct API {
        static let baseURL = "https://api.homescreen.app"
        static let timeout: TimeInterval = 30
        static let retryAttempts = 3
    }
    
    // MARK: - Debug Configuration
    struct Debug {
        #if DEBUG
        static let isDebugMode = true
        static let enableLogging = true
        static let showWidgetBorders = false
        #else
        static let isDebugMode = false
        static let enableLogging = false
        static let showWidgetBorders = false
        #endif
    }
}

// MARK: - Environment Detection
extension AppConfig {
    static var isRunningInSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    static var isRunningInPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
