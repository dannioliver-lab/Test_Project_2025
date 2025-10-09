import SwiftUI
import Foundation

/// Protocol that all home screen widgets must conform to
protocol HomeScreenWidget: Identifiable {
    /// Unique identifier for the widget
    var id: UUID { get }
    
    /// Display title of the widget
    var title: String { get }
    
    /// Widget size configuration
    var size: WidgetSize { get }
    
    /// The SwiftUI view body of the widget
    var body: any View { get }
    
    /// Whether the widget can be refreshed
    var isRefreshable: Bool { get }
    
    /// Refresh the widget data
    func refresh() async
}

/// Defines the size options for widgets
enum WidgetSize: CaseIterable {
    case small      // 1x1 grid
    case medium     // 2x1 grid
    case large      // 2x2 grid
    case extraLarge // 2x3 grid
    
    var gridItemSize: GridItem {
        switch self {
        case .small:
            return GridItem(.flexible(), spacing: 8)
        case .medium:
            return GridItem(.flexible(), spacing: 8)
        case .large:
            return GridItem(.flexible(), spacing: 8)
        case .extraLarge:
            return GridItem(.flexible(), spacing: 8)
        }
    }
    
    var height: CGFloat {
        switch self {
        case .small:
            return 120
        case .medium:
            return 120
        case .large:
            return 250
        case .extraLarge:
            return 350
        }
    }
}
