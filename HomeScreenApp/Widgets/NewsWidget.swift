import SwiftUI

class NewsWidget: BaseWidget {
    @Published var headlines: [NewsItem] = []
    
    init() {
        super.init(title: "Latest News", size: .large)
        Task {
            await refresh()
        }
    }
    
    override var contentView: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(headlines.prefix(3), id: \.id) { item in
                NewsItemView(item: item)
                
                if item.id != headlines.prefix(3).last?.id {
                    Divider()
                }
            }
            
            if headlines.isEmpty {
                VStack {
                    Image(systemName: "newspaper")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("Loading news...")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    override func refresh() async {
        await super.refresh()
        
        // Simulate news data loading
        let mockHeadlines = [
            NewsItem(title: "Tech Industry Sees Major Growth", summary: "Technology sector continues to expand with new innovations"),
            NewsItem(title: "Climate Change Summit Begins", summary: "World leaders gather to discuss environmental policies"),
            NewsItem(title: "New Medical Breakthrough", summary: "Researchers discover promising treatment for rare disease"),
            NewsItem(title: "Space Exploration Update", summary: "NASA announces new mission to Mars scheduled for next year"),
            NewsItem(title: "Economic Markets Update", summary: "Stock markets show positive trends across major indices")
        ]
        
        await MainActor.run {
            headlines = Array(mockHeadlines.shuffled().prefix(4))
        }
    }
}

struct NewsItem: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
}

struct NewsItemView: View {
    let item: NewsItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
                .foregroundColor(.primary)
            
            Text(item.summary)
                .font(.caption)
                .lineLimit(2)
                .foregroundColor(.secondary)
        }
    }
}
