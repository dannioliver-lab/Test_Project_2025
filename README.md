# Quick Actions Carousel Component

A horizontally scrolling carousel component for iOS that provides users with immediate, one-tap access to the most common app functions. Built with SwiftUI and designed for optimal performance and accessibility.

## Features

- ✨ **Smooth Horizontal Scrolling**: 60fps performance with native iOS scrolling behavior
- 🎯 **Haptic Feedback**: Light haptic feedback on tap interactions
- ♿ **Accessibility First**: Full VoiceOver support and Dynamic Type compatibility
- 🎨 **Customizable**: Easy to configure spacing, padding, and behavior
- 📱 **iOS 17+ Compatible**: Built with modern SwiftUI APIs

## Components

### QuickActionsCarousel
The main carousel component that displays a horizontally scrolling list of quick actions.

```swift
QuickActionsCarousel(
    actions: sampleActions,
    configuration: .default
)
```

### QuickActionCell
Individual action cells that display an icon and label with tap handling.

```swift
QuickActionCell(
    action: quickAction,
    configuration: .default
)
```

## Usage

### Basic Implementation

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            QuickActionsCarousel(actions: [
                QuickAction(
                    title: "Start Build",
                    iconName: "hammer.fill",
                    actionType: .build,
                    action: { 
                        print("Build started") 
                    }
                ),
                QuickAction(
                    title: "Scan Item",
                    iconName: "qrcode.viewfinder",
                    actionType: .scan,
                    action: { 
                        print("Scanner opened") 
                    }
                )
            ])
        }
    }
}
```

### Custom Configuration

```swift
let customConfig = CarouselConfiguration(
    itemSpacing: 20,
    horizontalPadding: 24,
    showsScrollIndicators: false,
    enableHapticFeedback: true
)

QuickActionsCarousel(
    actions: myActions,
    configuration: customConfig
)
```

## Data Models

### QuickAction
Represents a single quick action with icon, title, and action handler.

```swift
struct QuickAction {
    let title: String
    let iconName: String        // SF Symbol name
    let actionType: ActionType
    let action: () -> Void
}
```

### ActionType
Predefined action types with accessibility labels and descriptions.

```swift
enum ActionType {
    case build, scan, findTeammate, logExpense
    case createTask, viewReports, settings, help
}
```

### CarouselConfiguration
Configuration options for customizing carousel behavior.

```swift
struct CarouselConfiguration {
    let itemSpacing: CGFloat
    let horizontalPadding: CGFloat
    let showsScrollIndicators: Bool
    let enableHapticFeedback: Bool
}
```

## Accessibility

The component includes comprehensive accessibility support:

- **VoiceOver**: Each action cell is a distinct accessibility element
- **Dynamic Type**: Text labels respect system font size settings
- **Accessibility Labels**: Meaningful labels combining icon and text
- **Accessibility Hints**: Descriptive hints for each action type
- **Button Traits**: Proper accessibility traits for interactive elements

### Accessibility Labels Format
- Format: "Action: [Title]"
- Example: "Action: Start Build"

## Performance

- **LazyHStack**: Efficient view recycling for large datasets
- **60fps Scrolling**: Optimized for smooth performance
- **Minimal Redraws**: Efficient state management
- **Memory Efficient**: Lazy loading of off-screen content

## Integration

### Adding to Existing Projects

1. Copy the component files to your project:
   - `Components/QuickActionsCarousel.swift`
   - `Components/QuickActionCell.swift`
   - `Models/QuickAction.swift`
   - `Models/ActionType.swift`
   - `Utils/HapticManager.swift`

2. Import SwiftUI in your view:
   ```swift
   import SwiftUI
   ```

3. Add the carousel to your view hierarchy:
   ```swift
   QuickActionsCarousel(actions: yourActions)
   ```

### Customization Examples

#### Custom Action Types
```swift
// Extend ActionType for your app's specific actions
extension ActionType {
    case customAction
    
    var accessibilityLabel: String {
        switch self {
        case .customAction:
            return "Custom Action"
        default:
            return // ... existing cases
        }
    }
}
```

#### Custom Styling
```swift
// Modify QuickActionCell for custom appearance
struct CustomActionCell: View {
    // Custom implementation with your app's design system
}
```

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Architecture

The component follows a clean, modular architecture:

```
QuickActionsCarousel/
├── Models/
│   ├── QuickAction.swift      # Data model for actions
│   └── ActionType.swift       # Action type definitions
├── Components/
│   ├── QuickActionsCarousel.swift  # Main carousel component
│   └── QuickActionCell.swift       # Individual action cells
├── Utils/
│   └── HapticManager.swift         # Haptic feedback management
└── Data/
    └── SampleActions.swift         # Sample data for testing
```

## Sample Actions

The project includes sample actions for common use cases:

- **Start Build**: Development/CI actions
- **Scan Item**: QR/Barcode scanning
- **Find Teammate**: Team collaboration
- **Log Expense**: Financial tracking
- **Create Task**: Task management
- **View Reports**: Analytics and reporting
- **Settings**: App configuration
- **Help**: Support and documentation

## Best Practices

1. **Limit Action Count**: Keep 4-8 actions visible for optimal UX
2. **Consistent Icons**: Use SF Symbols for consistency
3. **Clear Labels**: Keep action titles short (1-2 words)
4. **Logical Ordering**: Place most important actions first
5. **Performance**: Test with your actual data set sizes

## Future Enhancements

Potential improvements for future versions:

- [ ] User customization (reordering, hiding actions)
- [ ] Drag-and-drop support
- [ ] Long press context menus
- [ ] Dynamic action loading
- [ ] Analytics integration
- [ ] Custom animation curves

## License

This component is part of the Quick Actions Carousel project and follows the project's licensing terms.

## Contributing

When contributing to this component:

1. Maintain accessibility compliance
2. Test performance with large datasets
3. Follow SwiftUI best practices
4. Update documentation for new features
5. Include unit tests for new functionality

---

Built with ❤️ using SwiftUI for iOS

