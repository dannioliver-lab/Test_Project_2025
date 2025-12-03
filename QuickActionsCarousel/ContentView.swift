import SwiftUI

struct ContentView: View {
    @State private var showSubscriptions = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Home")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Welcome back! Here are your quick actions:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Quick Actions Carousel
                QuickActionsCarousel(actions: SampleActions.defaultActions)
                
                // Subscriptions Button
                Button(action: {
                    showSubscriptions = true
                }) {
                    HStack {
                        Image(systemName: "crown.fill")
                        Text("View Subscriptions")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSubscriptions) {
                NavigationView {
                    SubscriptionsView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

