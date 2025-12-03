import SwiftUI

/// Minimal dark theme subscriptions page without gradient backgrounds
struct SubscriptionsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Solid dark background instead of gradient
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Choose Your Plan")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Simple, transparent pricing")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 40)
                    
                    // Subscription Tiers
                    VStack(spacing: 16) {
                        SubscriptionCard(
                            title: "Free",
                            price: "$0",
                            period: "forever",
                            features: [
                                "Basic features",
                                "Up to 5 projects",
                                "Community support"
                            ],
                            isPopular: false
                        )
                        
                        SubscriptionCard(
                            title: "Pro",
                            price: "$9.99",
                            period: "per month",
                            features: [
                                "All Free features",
                                "Unlimited projects",
                                "Priority support",
                                "Advanced analytics",
                                "Team collaboration"
                            ],
                            isPopular: true
                        )
                        
                        SubscriptionCard(
                            title: "Enterprise",
                            price: "$29.99",
                            period: "per month",
                            features: [
                                "All Pro features",
                                "Custom integrations",
                                "Dedicated account manager",
                                "SLA guarantee",
                                "Advanced security",
                                "Custom branding"
                            ],
                            isPopular: false
                        )
                    }
                    .padding(.horizontal)
                    
                    // Footer
                    Text("All plans include 14-day free trial")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
        }
    }
}

/// Minimal subscription card without gradient backgrounds
struct SubscriptionCard: View {
    let title: String
    let price: String
    let period: String
    let features: [String]
    let isPopular: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with popular badge
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                if isPopular {
                    Text("POPULAR")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white)
                        .cornerRadius(4)
                }
            }
            
            // Price
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(price)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                
                Text(period)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Divider()
                .background(Color.gray.opacity(0.3))
            
            // Features
            VStack(alignment: .leading, spacing: 12) {
                ForEach(features, id: \.self) { feature in
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                        
                        Text(feature)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
            }
            
            // Subscribe button
            Button(action: {
                print("Subscribe to \(title) plan")
            }) {
                Text("Subscribe")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(.top, 8)
        }
        .padding(20)
        .background(
            // Solid dark gray instead of gradient
            Color(white: 0.15)
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isPopular ? Color.white.opacity(0.3) : Color.clear, lineWidth: 2)
        )
    }
}

struct SubscriptionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SubscriptionsView()
        }
        .preferredColorScheme(.dark)
    }
}
