import SwiftUI

/// Represents a quick action that can be displayed in the carousel
struct QuickAction: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let iconName: String
    let actionType: ActionType
    let action: () -> Void
    
    init(title: String, iconName: String, actionType: ActionType, action: @escaping () -> Void) {
        self.title = title
        self.iconName = iconName
        self.actionType = actionType
        self.action = action
    }
    
    // Equatable conformance (ignoring the action closure)
    static func == (lhs: QuickAction, rhs: QuickAction) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.iconName == rhs.iconName &&
        lhs.actionType == rhs.actionType
    }
}

/// Configuration for the Quick Actions Carousel
struct CarouselConfiguration {
    let itemSpacing: CGFloat
    let horizontalPadding: CGFloat
    let showsScrollIndicators: Bool
    let enableHapticFeedback: Bool
    
    static let `default` = CarouselConfiguration(
        itemSpacing: 16,
        horizontalPadding: 20,
        showsScrollIndicators: false,
        enableHapticFeedback: true
    )
}

