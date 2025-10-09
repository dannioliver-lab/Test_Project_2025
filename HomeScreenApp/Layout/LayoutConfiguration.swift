import SwiftUI

struct LayoutConfiguration {
    var columnsCount: Int
    var spacing: CGFloat
    var padding: EdgeInsets
    var adaptiveLayout: Bool
    
    init(
        columnsCount: Int = 2,
        spacing: CGFloat = 16,
        padding: EdgeInsets = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16),
        adaptiveLayout: Bool = true
    ) {
        self.columnsCount = columnsCount
        self.spacing = spacing
        self.padding = padding
        self.adaptiveLayout = adaptiveLayout
    }
    
    var gridColumns: [GridItem] {
        if adaptiveLayout {
            return Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnsCount)
        } else {
            return Array(repeating: GridItem(.fixed(150), spacing: spacing), count: columnsCount)
        }
    }
    
    // Predefined layout configurations
    static let compact = LayoutConfiguration(
        columnsCount: 1,
        spacing: 12,
        padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
    )
    
    static let standard = LayoutConfiguration(
        columnsCount: 2,
        spacing: 16,
        padding: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
    )
    
    static let expanded = LayoutConfiguration(
        columnsCount: 3,
        spacing: 20,
        padding: EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
    )
}

// MARK: - Layout Utilities
extension LayoutConfiguration {
    func adaptedForScreenSize(_ screenSize: CGSize) -> LayoutConfiguration {
        guard adaptiveLayout else { return self }
        
        var config = self
        
        // Adjust columns based on screen width
        if screenSize.width < 375 {
            // Small screens (iPhone SE, etc.)
            config.columnsCount = 1
            config.spacing = 12
        } else if screenSize.width < 414 {
            // Standard iPhone screens
            config.columnsCount = 2
            config.spacing = 16
        } else {
            // Large screens (iPhone Plus, iPad, etc.)
            config.columnsCount = min(3, columnsCount)
            config.spacing = 20
        }
        
        return config
    }
    
    func withCustomSpacing(_ spacing: CGFloat) -> LayoutConfiguration {
        var config = self
        config.spacing = spacing
        return config
    }
    
    func withCustomPadding(_ padding: EdgeInsets) -> LayoutConfiguration {
        var config = self
        config.padding = padding
        return config
    }
}
