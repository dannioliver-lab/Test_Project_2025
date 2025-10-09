import SwiftUI

/// A reusable UI component that displays a personalized greeting to the user
/// This component adapts based on time of day and user preferences
struct PersonalizedGreetingView: View {
    // MARK: - Properties
    
    /// The user's name to display in the greeting
    let userName: String
    
    /// Optional custom greeting message
    let customMessage: String?
    
    /// Whether to show the time-based greeting (Good morning, afternoon, etc.)
    let showTimeBasedGreeting: Bool
    
    /// The current date/time for determining appropriate greeting
    private let currentDate: Date
    
    // MARK: - Initialization
    
    /// Initialize the PersonalizedGreetingView
    /// - Parameters:
    ///   - userName: The user's name to display
    ///   - customMessage: Optional custom message to override default greeting
    ///   - showTimeBasedGreeting: Whether to include time-based greeting (default: true)
    ///   - currentDate: The current date for time-based greetings (default: Date())
    init(
        userName: String,
        customMessage: String? = nil,
        showTimeBasedGreeting: Bool = true,
        currentDate: Date = Date()
    ) {
        self.userName = userName
        self.customMessage = customMessage
        self.showTimeBasedGreeting = showTimeBasedGreeting
        self.currentDate = currentDate
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Main greeting text
            Text(greetingText)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            // Subtitle with additional context
            if showTimeBasedGreeting {
                Text(timeBasedSubtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }
    
    // MARK: - Computed Properties
    
    /// The main greeting text to display
    private var greetingText: String {
        if let customMessage = customMessage {
            return customMessage.replacingOccurrences(of: "{name}", with: userName)
        }
        
        if showTimeBasedGreeting {
            return "\(timeBasedGreeting), \(userName)!"
        } else {
            return "Hello, \(userName)!"
        }
    }
    
    /// Time-based greeting (Good morning, Good afternoon, etc.)
    private var timeBasedGreeting: String {
        let hour = Calendar.current.component(.hour, from: currentDate)
        
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
    
    /// Subtitle text with additional context
    private var timeBasedSubtitle: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        
        return "Today is \(formatter.string(from: currentDate))"
    }
    
    /// Accessibility label for the entire greeting component
    private var accessibilityLabel: String {
        var label = greetingText
        if showTimeBasedGreeting {
            label += ". " + timeBasedSubtitle
        }
        return label
    }
}

// MARK: - Preview

#Preview("Default Greeting") {
    PersonalizedGreetingView(userName: "John")
        .padding()
}

#Preview("Custom Message") {
    PersonalizedGreetingView(
        userName: "Sarah",
        customMessage: "Welcome back, {name}! Ready for another great day?"
    )
    .padding()
}

#Preview("No Time-Based Greeting") {
    PersonalizedGreetingView(
        userName: "Alex",
        showTimeBasedGreeting: false
    )
    .padding()
}

#Preview("Different Times of Day") {
    VStack(spacing: 16) {
        // Morning
        PersonalizedGreetingView(
            userName: "Emma",
            currentDate: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
        )
        
        // Afternoon
        PersonalizedGreetingView(
            userName: "Emma",
            currentDate: Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date()) ?? Date()
        )
        
        // Evening
        PersonalizedGreetingView(
            userName: "Emma",
            currentDate: Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date()) ?? Date()
        )
        
        // Night
        PersonalizedGreetingView(
            userName: "Emma",
            currentDate: Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date()) ?? Date()
        )
    }
    .padding()
}
