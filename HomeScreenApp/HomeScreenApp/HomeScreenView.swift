import SwiftUI

struct HomeScreenView: View {
    @State private var contentItems: [ContentItem] = []
    @State private var isRefreshing = false
    @State private var lastRefreshTime = Date()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Header section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome Back!")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Last updated: \(lastRefreshTime, formatter: dateFormatter)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Content items
                ForEach(contentItems) { item in
                    ContentItemView(item: item)
                        .padding(.horizontal)
                }
                
                // Loading indicator when refreshing
                if isRefreshing {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Refreshing...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
            .padding(.vertical)
        }
        .refreshable {
            await refreshContent()
        }
        .onAppear {
            if contentItems.isEmpty {
                Task {
                    await loadInitialContent()
                }
            }
        }
    }
    
    // MARK: - Data Loading Methods
    
    @MainActor
    private func refreshContent() async {
        isRefreshing = true
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        // Generate fresh content
        contentItems = generateSampleContent()
        lastRefreshTime = Date()
        isRefreshing = false
    }
    
    @MainActor
    private func loadInitialContent() async {
        // Simulate initial loading
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        contentItems = generateSampleContent()
        lastRefreshTime = Date()
    }
    
    private func generateSampleContent() -> [ContentItem] {
        let sampleTitles = [
            "Breaking News Update",
            "Weather Forecast",
            "Your Daily Summary",
            "Trending Topics",
            "Recommended Articles",
            "Local Events",
            "Sports Highlights",
            "Market Updates"
        ]
        
        let sampleDescriptions = [
            "Stay informed with the latest developments",
            "Check today's weather conditions",
            "Your personalized daily briefing",
            "What's popular right now",
            "Articles picked just for you",
            "Discover what's happening nearby",
            "Latest scores and game highlights",
            "Financial market movements"
        ]
        
        return (0..<6).map { index in
            ContentItem(
                id: UUID(),
                title: sampleTitles[index % sampleTitles.count],
                description: sampleDescriptions[index % sampleDescriptions.count],
                timestamp: Date().addingTimeInterval(-Double.random(in: 0...3600)),
                category: ContentCategory.allCases.randomElement() ?? .news
            )
        }
    }
}

// MARK: - Supporting Views

struct ContentItemView: View {
    let item: ContentItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: item.category.iconName)
                        .font(.title2)
                        .foregroundColor(item.category.color)
                    
                    Text(item.category.rawValue)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Text(item.timestamp, formatter: timeFormatter)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("View") {
                    // Handle item tap
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Data Models

struct ContentItem: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let timestamp: Date
    let category: ContentCategory
}

enum ContentCategory: String, CaseIterable {
    case news = "News"
    case weather = "Weather"
    case sports = "Sports"
    case finance = "Finance"
    case local = "Local"
    case trending = "Trending"
    
    var iconName: String {
        switch self {
        case .news: return "newspaper"
        case .weather: return "cloud.sun"
        case .sports: return "sportscourt"
        case .finance: return "chart.line.uptrend.xyaxis"
        case .local: return "location"
        case .trending: return "flame"
        }
    }
    
    var color: Color {
        switch self {
        case .news: return .blue
        case .weather: return .orange
        case .sports: return .green
        case .finance: return .purple
        case .local: return .red
        case .trending: return .pink
        }
    }
}

// MARK: - Formatters

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

// MARK: - Preview

#Preview {
    NavigationView {
        HomeScreenView()
            .navigationTitle("Home")
    }
}
