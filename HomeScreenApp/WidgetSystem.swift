import SwiftUI
import Foundation

// MARK: - Widget Protocol
protocol HomeScreenWidget: Identifiable {
    var id: UUID { get }
    var title: String { get }
    var size: WidgetSize { get }
    var body: any View { get }
    var isRefreshable: Bool { get }
    func refresh() async
}

enum WidgetSize: CaseIterable {
    case small, medium, large, extraLarge
    
    var height: CGFloat {
        switch self {
        case .small: return 120
        case .medium: return 120
        case .large: return 250
        case .extraLarge: return 350
        }
    }
}

// MARK: - Base Widget Implementation
class BaseWidget: HomeScreenWidget, ObservableObject {
    let id = UUID()
    let title: String
    let size: WidgetSize
    let isRefreshable: Bool
    
    @Published var isLoading = false
    @Published var lastUpdated: Date?
    
    init(title: String, size: WidgetSize, isRefreshable: Bool = true) {
        self.title = title
        self.size = size
        self.isRefreshable = isRefreshable
    }
    
    var body: any View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                } else if isRefreshable {
                    Button(action: {
                        Task { await refresh() }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Content
            contentView
            
            Spacer()
            
            // Footer
            if let lastUpdated = lastUpdated {
                HStack {
                    Spacer()
                    Text("Updated \(lastUpdated, style: .relative) ago")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(16)
        .frame(height: size.height)
    }
    
    var contentView: some View {
        VStack {
            Image(systemName: "rectangle.dashed")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("Widget Content")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    func refresh() async {
        await MainActor.run { isLoading = true }
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        await MainActor.run {
            isLoading = false
            lastUpdated = Date()
        }
    }
}

// MARK: - Sample Widgets
class WeatherWidget: BaseWidget {
    @Published var temperature = "72°F"
    @Published var condition = "Sunny"
    
    init() {
        super.init(title: "Weather", size: .medium)
        Task { await refresh() }
    }
    
    override var contentView: some View {
        HStack(spacing: 16) {
            VStack {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.blue)
                Text(condition)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(temperature)
                    .font(.system(size: 28, weight: .light))
                    .foregroundColor(.primary)
                
                Text("Current Location")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    override func refresh() async {
        await super.refresh()
        let temps = ["68°F", "72°F", "75°F", "70°F"]
        let conditions = ["Sunny", "Cloudy", "Rainy", "Partly Cloudy"]
        
        await MainActor.run {
            temperature = temps.randomElement() ?? "72°F"
            condition = conditions.randomElement() ?? "Sunny"
        }
    }
}

class QuickActionsWidget: BaseWidget {
    let actions = [
        ("Messages", "message.fill", Color.green),
        ("Camera", "camera.fill", Color.blue),
        ("Calendar", "calendar", Color.red),
        ("Settings", "gear", Color.gray)
    ]
    
    init() {
        super.init(title: "Quick Actions", size: .medium, isRefreshable: false)
    }
    
    override var contentView: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(Array(actions.enumerated()), id: \.offset) { _, action in
                Button(action: {}) {
                    VStack(spacing: 6) {
                        Image(systemName: action.1)
                            .font(.title2)
                            .foregroundColor(.white)
                        Text(action.0)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(action.2)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

class NewsWidget: BaseWidget {
    @Published var headlines: [String] = []
    
    init() {
        super.init(title: "Latest News", size: .large)
        Task { await refresh() }
    }
    
    override var contentView: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(headlines.prefix(3), id: \.self) { headline in
                VStack(alignment: .leading, spacing: 4) {
                    Text(headline)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                    
                    Text("Technology sector continues to expand...")
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                }
                
                if headline != headlines.prefix(3).last {
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
        let mockHeadlines = [
            "Tech Industry Sees Major Growth",
            "Climate Change Summit Begins",
            "New Medical Breakthrough",
            "Space Exploration Update"
        ]
        
        await MainActor.run {
            headlines = Array(mockHeadlines.shuffled().prefix(3))
        }
    }
}

// MARK: - Layout Manager
class WidgetLayoutManager: ObservableObject {
    @Published var widgets: [any HomeScreenWidget] = []
    
    init() {
        setupDefaultWidgets()
    }
    
    var gridColumns: [GridItem] {
        [GridItem(.flexible()), GridItem(.flexible())]
    }
    
    private func setupDefaultWidgets() {
        widgets = [
            WeatherWidget(),
            QuickActionsWidget(),
            NewsWidget()
        ]
    }
}
