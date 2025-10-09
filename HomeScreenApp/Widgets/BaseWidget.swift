import SwiftUI
import Foundation

/// Base implementation for home screen widgets
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
            // Header with title and refresh indicator
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
                        Task {
                            await refresh()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Content area - to be overridden by subclasses
            contentView
            
            Spacer()
            
            // Footer with last updated time
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
    
    /// Override this in subclasses to provide custom content
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
    
    /// Override this in subclasses to implement refresh logic
    func refresh() async {
        await MainActor.run {
            isLoading = true
        }
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        await MainActor.run {
            isLoading = false
            lastUpdated = Date()
        }
    }
}
