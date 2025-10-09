import SwiftUI

class StatsWidget: BaseWidget {
    @Published var stats: [StatItem] = []
    
    init() {
        super.init(title: "Daily Stats", size: .small)
        Task {
            await refresh()
        }
    }
    
    override var contentView: some View {
        VStack(spacing: 8) {
            ForEach(stats.prefix(2), id: \.id) { stat in
                StatItemView(item: stat)
            }
            
            if stats.isEmpty {
                VStack {
                    Image(systemName: "chart.bar.fill")
                        .font(.title)
                        .foregroundColor(.secondary)
                    Text("Loading...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    override func refresh() async {
        await super.refresh()
        
        // Simulate stats data loading
        let mockStats = [
            StatItem(title: "Steps", value: "8,432", icon: "figure.walk", color: .green),
            StatItem(title: "Water", value: "6/8", icon: "drop.fill", color: .blue),
            StatItem(title: "Sleep", value: "7h 23m", icon: "moon.fill", color: .purple),
            StatItem(title: "Focus", value: "2h 15m", icon: "brain.head.profile", color: .orange)
        ]
        
        await MainActor.run {
            stats = Array(mockStats.shuffled().prefix(2))
        }
    }
}

struct StatItem: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let icon: String
    let color: Color
}

struct StatItemView: View {
    let item: StatItem
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: item.icon)
                .font(.caption)
                .foregroundColor(item.color)
                .frame(width: 16)
            
            Text(item.title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(item.value)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}
