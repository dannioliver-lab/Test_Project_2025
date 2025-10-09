# Personalized Greeting Component

A reusable SwiftUI component for displaying personalized greetings in iOS applications. This component adapts based on time of day and user preferences, making it perfect for home screen widgets and welcome screens.

## Features

- ✨ **Time-based greetings**: Automatically shows "Good morning", "Good afternoon", "Good evening", or "Good night" based on current time
- 🎨 **Customizable messages**: Support for custom greeting templates with name placeholders
- 📅 **Date display**: Optional subtitle showing the current date
- ♿ **Accessibility support**: Full VoiceOver support with proper accessibility labels
- 🎯 **Multiple styles**: Standard, compact, and prominent display styles
- 💾 **Preferences persistence**: Codable preferences for saving user customizations
- 🧪 **Comprehensive tests**: Unit tests, integration tests, and performance tests included

## Quick Start

### Basic Usage

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        PersonalizedGreetingView(userName: "John")
            .padding()
    }
}
```

### Custom Message

```swift
PersonalizedGreetingView(
    userName: "Sarah",
    customMessage: "Welcome back, {name}! Ready for another great day?"
)
```

### Without Time-Based Greeting

```swift
PersonalizedGreetingView(
    userName: "Alex",
    showTimeBasedGreeting: false
)
```

## Component Structure

### Files

- **`PersonalizedGreetingView.swift`**: Main SwiftUI component
- **`PersonalizedGreetingModel.swift`**: Data models and configuration
- **`PersonalizedGreetingTests.swift`**: Comprehensive test suite

### Key Components

#### PersonalizedGreetingView

The main SwiftUI view component that displays the greeting.

**Parameters:**
- `userName: String` - The user's name to display
- `customMessage: String?` - Optional custom message template (use `{name}` as placeholder)
- `showTimeBasedGreeting: Bool` - Whether to show time-based greetings (default: true)
- `currentDate: Date` - The current date for time-based greetings (default: Date())

#### PersonalizedGreetingConfiguration

Configuration model for setting up the greeting component.

```swift
let config = PersonalizedGreetingConfiguration(
    userName: "Emma",
    customMessage: "Hello, {name}!",
    showTimeBasedGreeting: true,
    showDateSubtitle: true,
    greetingStyle: .standard
)
```

#### GreetingTimeProvider

Utility class for generating time-based greetings and formatted dates.

```swift
let provider = GreetingTimeProvider()
let greeting = provider.getTimeBasedGreeting() // "Good morning", etc.
let date = provider.getFormattedDate() // "Wednesday, October 9, 2024"
```

#### GreetingPreferences

Codable preferences model for persisting user customizations.

```swift
var preferences = GreetingPreferences()
preferences.showTimeBasedGreeting = false
preferences.customMessage = "Hey there, {name}!"
preferences.greetingStyle = .prominent

// Save to UserDefaults or other storage
let data = try JSONEncoder().encode(preferences)
```

## Greeting Styles

The component supports three visual styles:

- **`.standard`**: Default style with balanced text sizes and spacing
- **`.compact`**: Smaller, more condensed layout for limited space
- **`.prominent`**: Larger, more eye-catching display for main screens

## Time-Based Greetings

The component automatically determines the appropriate greeting based on the current time:

- **5:00 AM - 11:59 AM**: "Good morning"
- **12:00 PM - 4:59 PM**: "Good afternoon"
- **5:00 PM - 8:59 PM**: "Good evening"
- **9:00 PM - 4:59 AM**: "Good night"

## Custom Messages

You can provide custom greeting messages using the `{name}` placeholder:

```swift
PersonalizedGreetingView(
    userName: "John",
    customMessage: "Welcome back, {name}! You have 3 new messages."
)
```

## Accessibility

The component includes comprehensive accessibility support:

- Proper accessibility labels that combine greeting and date information
- VoiceOver support for all text elements
- Semantic grouping of related content

## Testing

The component includes a comprehensive test suite:

### Running Tests

```bash
# Run all tests
xcodebuild test -scheme PersonalizedGreeting

# Run specific test class
xcodebuild test -scheme PersonalizedGreeting -only-testing:PersonalizedGreetingTests
```

### Test Coverage

- **Unit Tests**: Individual component functionality
- **Integration Tests**: Component interaction scenarios
- **Performance Tests**: Ensuring UI responsiveness
- **Boundary Tests**: Edge cases and time boundaries

## Integration Examples

### Home Screen Widget

```swift
struct HomeScreenView: View {
    @State private var userName = "User"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            PersonalizedGreetingView(userName: userName)
            
            // Other home screen content
            LazyVGrid(columns: gridColumns) {
                // App shortcuts, etc.
            }
        }
        .padding()
    }
}
```

### Settings Integration

```swift
struct GreetingSettingsView: View {
    @State private var preferences = GreetingPreferences()
    
    var body: some View {
        Form {
            Section("Greeting Options") {
                Toggle("Show Time-Based Greeting", isOn: $preferences.showTimeBasedGreeting)
                Toggle("Show Date", isOn: $preferences.showDateSubtitle)
            }
            
            Section("Custom Message") {
                TextField("Custom greeting (use {name} for name)", 
                         text: Binding(
                            get: { preferences.customMessage ?? "" },
                            set: { preferences.customMessage = $0.isEmpty ? nil : $0 }
                         ))
            }
        }
        .navigationTitle("Greeting Settings")
    }
}
```

## Requirements

- iOS 15.0+
- SwiftUI
- Xcode 13.0+

## Installation

1. Copy the `PersonalizedGreeting` folder to your project
2. Add the files to your Xcode project
3. Import and use the `PersonalizedGreetingView` in your SwiftUI views

## Contributing

When contributing to this component:

1. Ensure all tests pass
2. Add tests for new functionality
3. Follow Swift naming conventions
4. Update documentation for API changes
5. Consider accessibility implications

## License

This component is part of the Home Screen Revamp project and follows the project's licensing terms.
