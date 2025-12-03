# Test Project 2025

This repository contains multiple demo applications and a fully-functional subscription tracker.

## Projects

### 1. 💳 Subscription Tracker Web App (NEW!)

A beautiful web application to track all your online subscriptions including Netflix, Disney+, Spotify, and more!

**Features:**
- ✅ View all subscriptions in a beautiful card layout
- ✅ Track monthly costs and see total spending
- ✅ Monitor payment due dates with visual indicators
- ✅ Store credit card information (last 4 digits) per subscription
- ✅ Add, edit, and delete subscriptions
- ✅ Data persists in browser local storage
- ✅ Fully responsive design

**Location:** `/webapp/`

**Screenshots:**

![Subscription Tracker Empty State](https://github.com/user-attachments/assets/b2b8874a-425f-40fd-a061-2a1d17dbda5e)

![Subscription Tracker with Data](https://github.com/user-attachments/assets/c27dc345-867f-4d78-8a4e-d53c4f62a904)

![Add Subscription Form](https://github.com/user-attachments/assets/22995139-94b9-4606-93b6-aef223f31fc8)

**Quick Start:**
```bash
cd webapp
python3 -m http.server 8080
# Open http://localhost:8080 in your browser
```

See [webapp/README.md](webapp/README.md) for full documentation.

---

### 2. 📱 Subscription Tracker Android App (NEW!)

A native Android application for tracking subscriptions, integrated into the existing observing app.

**Features:**
- ✅ Room database for persistent storage
- ✅ MVVM architecture with LiveData
- ✅ Material Design UI components
- ✅ RecyclerView with DiffUtil for efficient updates
- ✅ Add/Edit/Delete subscriptions with dialog interface
- ✅ Total monthly cost calculation
- ✅ Days until payment tracking

**Location:** `/app/` (integrated into existing Android app)

**Key Components:**
- `Subscription.kt` - Data model with helper methods
- `SubscriptionDao.kt` - Room database access object
- `SubscriptionViewModel.kt` - ViewModel with LiveData
- `SubscriptionsActivity.kt` - Main subscription list activity
- `AddEditSubscriptionDialog.kt` - Add/edit dialog fragment

---

### 3. Pull to Refresh Demo

A comprehensive iOS application demonstrating pull-to-refresh functionality using `UIRefreshControl` with proper error handling, loading states, and smooth animations.

## 🎯 Features

- **Native Pull-to-Refresh**: Uses standard iOS `UIRefreshControl` for familiar user experience
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Loading States**: Smooth loading animations and visual feedback
- **Accessibility**: Full accessibility support with proper labels and hints
- **Modern Architecture**: Clean MVC architecture with separation of concerns
- **Responsive Design**: Works on all iOS devices and orientations

## 📱 Screenshots

The app demonstrates:
- Standard iOS pull-to-refresh behavior
- Loading spinner during data fetch
- Success feedback with subtle animations
- Error states with retry options
- Smooth transitions and animations

## 🛠 Technical Implementation

### Architecture

The app follows a clean MVC (Model-View-Controller) architecture:

```
PullToRefreshDemo/
├── Controllers/
│   └── MainListViewController.swift    # Main view controller with pull-to-refresh
├── Views/
│   ├── ListItemTableViewCell.swift     # Custom table view cell
│   └── LoadingView.swift               # Custom loading indicator
├── Models/
│   └── ListItem.swift                  # Data model for list items
├── Services/
│   ├── DataService.swift               # Data fetching service
│   └── NetworkError.swift              # Error handling types
└── Utils/
    └── AlertHelper.swift               # Alert and notification utilities
```

### Key Components

#### UIRefreshControl Integration
```swift
private func setupRefreshControl() {
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    refreshControl.tintColor = UIColor.systemBlue
    tableView.refreshControl = refreshControl
}
```

#### Error Handling
```swift
enum NetworkError: Error {
    case noInternetConnection
    case serverError(Int)
    case timeout
    case invalidData
    case unknown(Error)
}
```

#### Data Service
```swift
class DataService {
    func refreshData(completion: @escaping (Result<[ListItem], NetworkError>) -> Void) {
        // Simulates network request with proper error handling
    }
}
```

## 🚀 Getting Started

### Prerequisites

- Xcode 14.0 or later
- iOS 13.0 or later
- Swift 5.0 or later

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd PullToRefreshDemo
```

2. Open the project in Xcode:
```bash
open PullToRefreshDemo.xcodeproj
```

3. Build and run the project:
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### Usage

1. **Pull to Refresh**: Pull down on the list to trigger a refresh
2. **Loading State**: Watch the spinner animation during data loading
3. **Success Feedback**: See the subtle success indicator after refresh
4. **Error Handling**: Experience error states and retry functionality
5. **Accessibility**: Use VoiceOver to test accessibility features

## 🎨 Customization

### Refresh Control Appearance
```swift
refreshControl.tintColor = UIColor.systemBlue
refreshControl.attributedTitle = NSAttributedString(
    string: "Pull to refresh",
    attributes: [.foregroundColor: UIColor.secondaryLabel]
)
```

### Error Messages
Customize error messages in `NetworkError.swift`:
```swift
var localizedDescription: String {
    switch self {
    case .noInternetConnection:
        return "No internet connection. Please check your network and try again."
    // ... other cases
    }
}
```

### Loading Animation
Modify loading behavior in `LoadingView.swift`:
```swift
func startAnimating(animated: Bool = true) {
    // Custom animation logic
}
```

## 📋 Requirements Fulfilled

✅ **Pull-to-refresh trigger**: When user is at top of list, dragging down triggers refresh  
✅ **Standard iOS spinner**: Uses `UIRefreshControl` with native appearance  
✅ **Loading behavior**: Spinner stays visible until data is ready  
✅ **Success handling**: Hides spinner and shows new content smoothly  
✅ **Error handling**: Shows friendly error messages with retry options  
✅ **List implementation**: Works on standard table view screens  

## 🧪 Testing

The app includes simulated network conditions for testing:

- **Success scenarios**: Normal data loading and refresh
- **Network errors**: No internet connection simulation
- **Server errors**: HTTP error code simulation  
- **Timeout errors**: Request timeout simulation
- **Retry functionality**: Error recovery testing

## 🔧 Configuration

### Deployment Target
- Minimum iOS version: 13.0
- Supports iPhone and iPad
- Portrait and landscape orientations

### Build Settings
- Swift version: 5.0
- Deployment target: iOS 13.0
- Architecture: Universal (arm64, x86_64)

## 📚 Learning Resources

This implementation demonstrates:

1. **UIRefreshControl**: Native iOS pull-to-refresh component
2. **Result Type**: Modern Swift error handling patterns
3. **Async Operations**: Proper background/main thread management
4. **UI Animations**: Smooth transitions and feedback
5. **Accessibility**: VoiceOver and accessibility best practices
6. **MVC Architecture**: Clean separation of concerns

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is created for demonstration purposes. Feel free to use and modify as needed.

## 🙋‍♂️ Support

If you have questions or need help with the implementation:

1. Check the inline code documentation
2. Review the `IMPLEMENTATION.md` file for detailed technical notes
3. Open an issue for bugs or feature requests

---

**Built with ❤️ using Swift and UIKit**
