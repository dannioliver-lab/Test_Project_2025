# Home Screen iOS App

A modern iOS application that integrates with the v2 API endpoint to display a comprehensive home screen dashboard.

## 🚀 Features

- **User Welcome Section**: Personalized greeting with user avatar and role information
- **Stats Overview**: Visual progress tracking with completion percentages and task statistics
- **Quick Actions**: Easy access to frequently used features
- **Recent Activities**: Timeline of recent user activities and system events
- **Notifications**: Real-time notifications with different priority levels
- **Pull-to-Refresh**: Seamless data refreshing with SwiftUI's native pull-to-refresh
- **Error Handling**: Comprehensive error states with retry functionality
- **Loading States**: Smooth loading animations and skeleton views

## 🏗️ Architecture

This app follows the **MVVM (Model-View-ViewModel)** architecture pattern with clean separation of concerns:

### Project Structure

```
HomeScreenApp/
├── Models/                 # Data models and entities
│   ├── HomeData.swift     # Main home screen data model
│   ├── User.swift         # User model with preferences
│   └── Activity.swift     # Activity and notification models
├── Services/              # Network and business logic
│   ├── NetworkService.swift    # Main networking service
│   ├── APIEndpoints.swift      # API endpoint definitions
│   └── NetworkError.swift      # Error handling
├── ViewModels/            # Business logic and state management
│   └── HomeViewModel.swift     # Home screen view model
├── Views/                 # SwiftUI views and components
│   ├── HomeView.swift          # Main home screen view
│   └── Components/             # Reusable UI components
│       ├── LoadingView.swift
│       └── ErrorView.swift
├── Configuration/         # App configuration and settings
│   └── AppConfig.swift         # Centralized app configuration
└── Resources/             # Assets and configuration files
    └── Info.plist             # App metadata and permissions
```

## 🔌 API Integration

The app integrates with the `/api/v2/home` endpoint to fetch comprehensive home screen data:

### Expected API Response Structure

```json
{
  "user": {
    "id": "string",
    "name": "string",
    "email": "string",
    "avatar_url": "string",
    "role": "string",
    "department": "string",
    "last_login_at": "2023-10-01T12:00:00.000000Z",
    "preferences": {
      "theme": "string",
      "notifications": boolean,
      "language": "string",
      "timezone": "string"
    }
  },
  "recent_activities": [
    {
      "id": "string",
      "title": "string",
      "description": "string",
      "type": "task_completed",
      "timestamp": "2023-10-01T12:00:00.000000Z",
      "status": "completed",
      "metadata": {}
    }
  ],
  "notifications": [
    {
      "id": "string",
      "title": "string",
      "message": "string",
      "type": "info",
      "timestamp": "2023-10-01T12:00:00.000000Z",
      "is_read": boolean
    }
  ],
  "quick_actions": [
    {
      "id": "string",
      "title": "string",
      "icon": "plus.circle",
      "action": "create_task",
      "is_enabled": boolean
    }
  ],
  "stats": {
    "total_tasks": 25,
    "completed_tasks": 18,
    "pending_tasks": 7,
    "upcoming_deadlines": 3
  }
}
```

## 🛠️ Technical Implementation

### Key Technologies

- **SwiftUI**: Modern declarative UI framework
- **Combine**: Reactive programming for data binding
- **URLSession**: Native networking with async/await
- **Swift Concurrency**: Modern async/await patterns
- **MVVM Architecture**: Clean separation of concerns

### Networking Layer

The networking layer is built with:

- **Protocol-based design** for easy testing and mocking
- **Comprehensive error handling** with custom error types
- **Automatic JSON decoding** with proper date formatting
- **Request/response validation** with HTTP status code handling
- **Authentication support** (ready for Bearer token integration)

### State Management

- **@StateObject** and **@ObservableObject** for reactive state management
- **@Published** properties for automatic UI updates
- **Task-based async operations** for network calls
- **Error state management** with user-friendly error messages

## 🚀 Getting Started

### Prerequisites

- Xcode 15.0 or later
- iOS 16.0 or later
- Swift 5.9 or later

### Configuration

1. **API Endpoint Configuration**:
   Update the base URL in `APIConfiguration.swift`:
   ```swift
   static let baseURL = "https://your-api-domain.com"
   ```

2. **Authentication** (if required):
   Implement the `getAuthToken()` method in `NetworkService.swift` to provide authentication tokens.

3. **Feature Flags**:
   Adjust feature flags in `AppConfig.swift` as needed:
   ```swift
   static let enableMockData = false  // Set to true for development
   ```

### Running the App

1. Open the project in Xcode
2. Select your target device or simulator
3. Build and run the project (⌘+R)

### Development Mode

For development and testing, you can enable mock data by:

1. Setting `AppConfig.Features.enableMockData = true`
2. The app will use `MockNetworkService` instead of making real API calls
3. This provides realistic sample data for UI development and testing

## 🧪 Testing

The app includes:

- **Mock Network Service** for UI testing and development
- **Protocol-based architecture** for easy unit testing
- **Comprehensive error scenarios** for robust error handling testing

### Running Tests

```bash
# Run unit tests
xcodebuild test -scheme HomeScreenApp -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 🔧 Customization

### Adding New Quick Actions

1. Update the API response to include new actions
2. Add handling in `HomeViewModel.handleQuickAction(_:)`
3. The UI will automatically adapt to display new actions

### Modifying UI Components

- All UI components are modular and reusable
- Styling constants are centralized in `AppConfig.UI`
- Colors and fonts follow iOS design guidelines

### Adding New Activity Types

1. Add new cases to `ActivityType` enum in `Activity.swift`
2. Update the color mapping in `ActivityRow.colorForActivityType(_:)`
3. The UI will automatically handle the new activity types

## 📱 Supported Features

- ✅ iOS 16.0+ compatibility
- ✅ Dark mode support
- ✅ Dynamic Type support
- ✅ VoiceOver accessibility
- ✅ Pull-to-refresh
- ✅ Error handling and retry
- ✅ Loading states
- ✅ Offline graceful degradation

## 🤝 Contributing

1. Follow the existing MVVM architecture
2. Add appropriate error handling for new features
3. Include unit tests for new functionality
4. Follow Swift naming conventions and code style
5. Update documentation for significant changes

## 📄 License

This project is part of the Home Screen Revamp initiative and follows company development guidelines.

---

**Note**: This app is designed to work with the v2 API endpoint. Ensure your backend API matches the expected response structure for optimal functionality.
