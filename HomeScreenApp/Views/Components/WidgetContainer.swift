import SwiftUI

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
    WidgetContainer(widget: WeatherWidget())
        .frame(height: 200)
        .padding()
}
