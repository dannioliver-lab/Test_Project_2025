import Foundation

/// Represents a single item in the list
struct ListItem {
    let id: String
    let title: String
    let subtitle: String
    let timestamp: Date
    
    init(id: String = UUID().uuidString, title: String, subtitle: String, timestamp: Date = Date()) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.timestamp = timestamp
    }
}

// MARK: - Equatable
extension ListItem: Equatable {
    static func == (lhs: ListItem, rhs: ListItem) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Sample Data
extension ListItem {
    static func sampleData() -> [ListItem] {
        return [
            ListItem(title: "Welcome to Pull-to-Refresh", subtitle: "Pull down to refresh the list"),
            ListItem(title: "iOS Development", subtitle: "Building great user experiences"),
            ListItem(title: "UIRefreshControl", subtitle: "Native iOS refresh functionality"),
            ListItem(title: "Swift Programming", subtitle: "Modern and powerful language"),
            ListItem(title: "Mobile Apps", subtitle: "Creating apps for iOS devices"),
            ListItem(title: "User Interface", subtitle: "Designing intuitive interfaces"),
            ListItem(title: "Data Loading", subtitle: "Fetching content from services"),
            ListItem(title: "Error Handling", subtitle: "Graceful failure management"),
            ListItem(title: "Performance", subtitle: "Optimizing app responsiveness"),
            ListItem(title: "Best Practices", subtitle: "Following iOS guidelines")
        ]
    }
    
    static func newSampleData() -> [ListItem] {
        let titles = [
            "Breaking News", "Technology Update", "Weather Alert", "Sports Score",
            "Market Update", "Social Media", "Entertainment", "Health Tips",
            "Travel Guide", "Food Recipe", "Science Discovery", "Art Exhibition"
        ]
        
        let subtitles = [
            "Latest developments", "New features available", "Current conditions",
            "Live updates", "Real-time data", "Trending now", "What's happening",
            "Expert advice", "Recommendations", "Step by step", "Recent findings",
            "Now showing"
        ]
        
        return (0..<10).map { index in
            ListItem(
                title: titles.randomElement() ?? "Item \(index + 1)",
                subtitle: subtitles.randomElement() ?? "Updated content"
            )
        }
    }
}
