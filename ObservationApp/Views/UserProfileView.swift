import SwiftUI
import Combine

struct UserProfileView: View {
    let user: User
    @StateObject private var statsService = UserStatsService()
    @State private var userStats: UserStatistics?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header Section
                    ProfileHeaderView(user: user)
                    
                    // Statistics Dashboard
                    if isLoading {
                        LoadingStateView()
                    } else if let stats = userStats {
                        if stats.isEmpty {
                            EmptyStateView()
                        } else {
                            StatisticsDashboardView(statistics: stats)
                        }
                    } else if let error = errorMessage {
                        ErrorStateView(message: error) {
                            loadUserStatistics()
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            loadUserStatistics()
        }
    }
    
    private func loadUserStatistics() {
        isLoading = true
        errorMessage = nil
        
        // For demo purposes, using mock data
        // In production, use: statsService.fetchUserStatistics(for: user.id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.userStats = self.statsService.fetchMockUserStatistics(for: self.user.id)
            self.isLoading = false
        }
    }
}

struct ProfileHeaderView: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 16) {
            // User Avatar
            AsyncImage(url: URL(string: user.avatarURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.gray)
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            
            // User Info
            VStack(spacing: 8) {
                Text(user.displayName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(user.username)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Member Since Badge
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                    Text("Member since \(user.memberSince, formatter: memberSinceDateFormatter)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
            
            // Edit Profile Button
            Button(action: {
                // Navigate to settings/edit profile
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit Profile")
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.blue)
                .cornerRadius(20)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct StatisticsDashboardView: View {
    let statistics: UserStatistics
    
    var body: some View {
        VStack(spacing: 20) {
            // Total Observations Counter
            StatCardView(
                title: "Total Observations",
                value: "\(statistics.totalObservations)",
                icon: "eye.fill",
                color: .green
            )
            
            // Recent Activity Section
            RecentActivityView(observations: statistics.recentActivity)
            
            // Category Breakdown Chart
            CategoryBreakdownView(categoryBreakdown: statistics.categoryBreakdown)
            
            // Streak/Engagement Section
            if statistics.currentStreak > 0 {
                StreakView(streak: statistics.currentStreak, lastActive: statistics.lastActiveDate)
            }
        }
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(value)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(color)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct RecentActivityView: View {
    let observations: [Observation]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activity")
                .font(.headline)
                .padding(.horizontal)
            
            LazyVStack(spacing: 8) {
                ForEach(observations.prefix(5)) { observation in
                    RecentActivityRowView(observation: observation)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct RecentActivityRowView: View {
    let observation: Observation
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(observation.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(observation.createdAt, formatter: relativeDateFormatter)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            StatusBadgeView(status: observation.status)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

struct StatusBadgeView: View {
    let status: ObservationStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.2))
            .foregroundColor(statusColor)
            .cornerRadius(8)
    }
    
    private var statusColor: Color {
        switch status {
        case .verified:
            return .green
        case .pending:
            return .orange
        case .rejected:
            return .red
        }
    }
}

struct CategoryBreakdownView: View {
    let categoryBreakdown: [ObservationCategory: Int]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category Breakdown")
                .font(.headline)
                .padding(.horizontal)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(ObservationCategory.allCases, id: \.self) { category in
                    CategoryCardView(
                        category: category,
                        count: categoryBreakdown[category] ?? 0
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct CategoryCardView: View {
    let category: ObservationCategory
    let count: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: categoryIcon)
                .font(.system(size: 24))
                .foregroundColor(categoryColor)
            
            Text(category.rawValue)
                .font(.caption)
                .fontWeight(.medium)
            
            Text("\(count)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(categoryColor)
        }
        .padding()
        .background(categoryColor.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var categoryIcon: String {
        switch category {
        case .flora:
            return "leaf.fill"
        case .fauna:
            return "pawprint.fill"
        case .weather:
            return "cloud.fill"
        case .geology:
            return "mountain.2.fill"
        case .other:
            return "questionmark.circle.fill"
        }
    }
    
    private var categoryColor: Color {
        switch category {
        case .flora:
            return .green
        case .fauna:
            return .brown
        case .weather:
            return .blue
        case .geology:
            return .gray
        case .other:
            return .purple
        }
    }
}

struct StreakView: View {
    let streak: Int
    let lastActive: Date?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Current Streak")
                    .font(.headline)
                
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(streak) days")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                
                if let lastActive = lastActive {
                    Text("Last active: \(lastActive, formatter: relativeDateFormatter)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct LoadingStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading your statistics...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(40)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "eye.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No observations yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Start exploring!")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                // Navigate to create observation
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Create Observation")
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(20)
            }
        }
        .padding(40)
    }
}

struct ErrorStateView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Error Loading Data")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: onRetry) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(20)
            }
        }
        .padding(40)
    }
}

// MARK: - Date Formatters

private let memberSinceDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

private let relativeDateFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .abbreviated
    return formatter
}()

// MARK: - Preview

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(user: User(
            displayName: "John Doe",
            username: "johndoe",
            email: "john@example.com",
            memberSince: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date()
        ))
    }
}
