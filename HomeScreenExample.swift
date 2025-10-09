import SwiftUI

struct HomeScreenExample: View {
    @State private var userName = "Emma"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Simple greeting
                GreetingWidget(userName)
                
                // Custom message greeting
                GreetingWidget(userName, message: "Ready to conquer today, {name}?")
                
                // Other home screen content would go here
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    ForEach(0..<6) { index in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.blue.opacity(0.1))
                            .frame(height: 100)
                            .overlay {
                                Text("Widget \(index + 1)")
                                    .foregroundStyle(.secondary)
                            }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Home")
    }
}

#Preview {
    NavigationView {
        HomeScreenExample()
    }
}
