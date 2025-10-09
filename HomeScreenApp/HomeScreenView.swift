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

struct WidgetContainer: View {
    let widget: any HomeScreenWidget
    
    var body: some View {
        VStack(spacing: 0) {
            AnyView(widget.body)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    HomeScreenView()
}
