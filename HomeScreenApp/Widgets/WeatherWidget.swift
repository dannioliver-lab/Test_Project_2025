import SwiftUI

class WeatherWidget: BaseWidget {
    @Published var temperature = "--"
    @Published var condition = "Loading..."
    @Published var location = "Current Location"
    
    init() {
        super.init(title: "Weather", size: .medium)
        Task {
            await refresh()
        }
    }
    
    override var contentView: some View {
        HStack(spacing: 16) {
            // Weather icon
            VStack {
                Image(systemName: weatherIcon)
                    .font(.system(size: 32))
                    .foregroundColor(.blue)
                Text(condition)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Temperature and location
            VStack(alignment: .trailing) {
                Text(temperature)
                    .font(.system(size: 28, weight: .light))
                    .foregroundColor(.primary)
                
                Text(location)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
    
    private var weatherIcon: String {
        switch condition {
        case "Sunny":
            return "sun.max.fill"
        case "Cloudy":
            return "cloud.fill"
        case "Rainy":
            return "cloud.rain.fill"
        default:
            return "cloud.sun.fill"
        }
    }
    
    override func refresh() async {
        await super.refresh()
        
        // Simulate weather data loading
        let mockTemperatures = ["72°F", "68°F", "75°F", "70°F", "73°F"]
        let mockConditions = ["Sunny", "Cloudy", "Rainy", "Partly Cloudy"]
        
        await MainActor.run {
            temperature = mockTemperatures.randomElement() ?? "72°F"
            condition = mockConditions.randomElement() ?? "Sunny"
        }
    }
}
