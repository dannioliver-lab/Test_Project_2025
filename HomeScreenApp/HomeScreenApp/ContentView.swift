import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            HomeScreenView()
                .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
}
