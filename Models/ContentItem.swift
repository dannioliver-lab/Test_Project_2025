import Foundation

struct ContentItem {
    let id: UUID
    let title: String
    let subtitle: String
    let timestamp: Date
    
    init(title: String, subtitle: String) {
        self.id = UUID()
        self.title = title
        self.subtitle = subtitle
        self.timestamp = Date()
    }
}

// MARK: - Sample Data
extension ContentItem {
    static func sampleData() -> [ContentItem] {
        return [
            ContentItem(title: "Welcome to Home Screen", subtitle: "Pull down to refresh content"),
            ContentItem(title: "Latest Updates", subtitle: "Stay up to date with the latest news"),
            ContentItem(title: "Featured Content", subtitle: "Discover trending topics and articles"),
            ContentItem(title: "Personalized Feed", subtitle: "Content tailored just for you"),
            ContentItem(title: "Recent Activity", subtitle: "See what's happening around you"),
            ContentItem(title: "Notifications", subtitle: "Important updates and messages"),
            ContentItem(title: "Trending Now", subtitle: "Popular content in your area"),
            ContentItem(title: "Recommended", subtitle: "Based on your interests and activity")
        ]
    }
    
    static func refreshedData() -> [ContentItem] {
        let refreshTitles = [
            "🔄 Refreshed Content",
            "✨ New Updates Available",
            "📱 Fresh Feed Items",
            "🎯 Updated Recommendations",
            "🌟 Latest Trending Topics",
            "📰 Breaking News",
            "🔥 Hot Topics",
            "💡 New Insights"
        ]
        
        let refreshSubtitles = [
            "Content updated just now",
            "Fresh data loaded successfully",
            "New items added to your feed",
            "Updated recommendations available",
            "Latest content synchronized",
            "Real-time updates applied",
            "Fresh content delivered",
            "New data refreshed"
        ]
        
        return (0..<8).map { index in
            ContentItem(
                title: refreshTitles[index % refreshTitles.count],
                subtitle: refreshSubtitles[index % refreshSubtitles.count]
            )
        }
    }
}
