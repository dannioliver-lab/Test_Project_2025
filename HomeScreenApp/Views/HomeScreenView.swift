import SwiftUI

struct HomeScreenView: View {
    @StateObject private var layoutManager = WidgetLayoutManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: layoutManager.gridColumns, spacing: 16) {
                    ForEach(layoutManager.widgets, id: \.id) { widget in
                        WidgetContainer(widget: widget)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HomeScreenView()
}
