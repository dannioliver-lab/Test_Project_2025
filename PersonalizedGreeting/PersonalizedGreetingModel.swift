import Foundation

/// Configuration model for personalized greetings
struct PersonalizedGreetingConfiguration {
    // MARK: - Properties
    
    /// The user's display name
    let userName: String
    
    /// Custom greeting message template (use {name} as placeholder)
    let customMessage: String?
    
    /// Whether to show time-based greetings
    let showTimeBasedGreeting: Bool
    
    /// Whether to show the date subtitle
    let showDateSubtitle: Bool
    
    /// Preferred greeting style
    let greetingStyle: GreetingStyle
    
    // MARK: - Initialization
    
    /// Initialize with default values
    /// - Parameters:
    ///   - userName: The user's display name
    ///   - customMessage: Optional custom message template
    ///   - showTimeBasedGreeting: Whether to show time-based greetings (default: true)
    ///   - showDateSubtitle: Whether to show date subtitle (default: true)
    ///   - greetingStyle: The visual style for the greeting (default: .standard)
    init(
        userName: String,
        customMessage: String? = nil,
        showTimeBasedGreeting: Bool = true,
        showDateSubtitle: Bool = true,
        greetingStyle: GreetingStyle = .standard
    ) {
        self.userName = userName
        self.customMessage = customMessage
        self.showTimeBasedGreeting = showTimeBasedGreeting
        self.showDateSubtitle = showDateSubtitle
        self.greetingStyle = greetingStyle
    }
}

/// Visual styles for the greeting component
enum GreetingStyle: CaseIterable {
    case standard
    case compact
    case prominent
    
    /// Display name for the style
    var displayName: String {
        switch self {
        case .standard:
            return "Standard"
        case .compact:
            return "Compact"
        case .prominent:
            return "Prominent"
        }
    }
}

/// Time-based greeting provider
struct GreetingTimeProvider {
    // MARK: - Properties
    
    private let calendar: Calendar
    private let currentDate: Date
    
    // MARK: - Initialization
    
    /// Initialize with current date and calendar
    /// - Parameters:
    ///   - currentDate: The current date (default: Date())
    ///   - calendar: The calendar to use (default: Calendar.current)
    init(currentDate: Date = Date(), calendar: Calendar = Calendar.current) {
        self.currentDate = currentDate
        self.calendar = calendar
    }
    
    // MARK: - Public Methods
    
    /// Get the appropriate time-based greeting
    /// - Returns: A greeting string based on the current time
    func getTimeBasedGreeting() -> String {
        let hour = calendar.component(.hour, from: currentDate)
        
        switch hour {
        case 5..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        case 17..<21:
            return "Good evening"
        default:
            return "Good night"
        }
    }
    
    /// Get a formatted date string for display
    /// - Returns: A formatted date string
    func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter.string(from: currentDate)
    }
    
    /// Get the current hour for testing purposes
    /// - Returns: The current hour (0-23)
    func getCurrentHour() -> Int {
        return calendar.component(.hour, from: currentDate)
    }
}

/// User preferences for greeting customization
struct GreetingPreferences: Codable {
    // MARK: - Properties
    
    /// Whether to show time-based greetings
    var showTimeBasedGreeting: Bool = true
    
    /// Whether to show the date subtitle
    var showDateSubtitle: Bool = true
    
    /// Custom greeting message template
    var customMessage: String?
    
    /// Preferred greeting style
    var greetingStyle: GreetingStyle = .standard
    
    /// Whether to use 24-hour format for time display
    var use24HourFormat: Bool = false
    
    // MARK: - Coding Keys
    
    private enum CodingKeys: String, CodingKey {
        case showTimeBasedGreeting
        case showDateSubtitle
        case customMessage
        case greetingStyle
        case use24HourFormat
    }
    
    // MARK: - Codable Implementation
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        showTimeBasedGreeting = try container.decodeIfPresent(Bool.self, forKey: .showTimeBasedGreeting) ?? true
        showDateSubtitle = try container.decodeIfPresent(Bool.self, forKey: .showDateSubtitle) ?? true
        customMessage = try container.decodeIfPresent(String.self, forKey: .customMessage)
        
        // Handle GreetingStyle decoding with fallback
        if let styleRawValue = try container.decodeIfPresent(String.self, forKey: .greetingStyle) {
            switch styleRawValue {
            case "standard":
                greetingStyle = .standard
            case "compact":
                greetingStyle = .compact
            case "prominent":
                greetingStyle = .prominent
            default:
                greetingStyle = .standard
            }
        } else {
            greetingStyle = .standard
        }
        
        use24HourFormat = try container.decodeIfPresent(Bool.self, forKey: .use24HourFormat) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(showTimeBasedGreeting, forKey: .showTimeBasedGreeting)
        try container.encode(showDateSubtitle, forKey: .showDateSubtitle)
        try container.encodeIfPresent(customMessage, forKey: .customMessage)
        
        // Encode GreetingStyle as string
        let styleRawValue: String
        switch greetingStyle {
        case .standard:
            styleRawValue = "standard"
        case .compact:
            styleRawValue = "compact"
        case .prominent:
            styleRawValue = "prominent"
        }
        try container.encode(styleRawValue, forKey: .greetingStyle)
        
        try container.encode(use24HourFormat, forKey: .use24HourFormat)
    }
}
