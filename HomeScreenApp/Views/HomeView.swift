import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && !viewModel.hasData {
                    LoadingView()
                } else if viewModel.showError {
                    ErrorView(
                        message: viewModel.errorMessage ?? "An unknown error occurred",
                        onRetry: {
                            Task {
                                await viewModel.refreshData()
                            }
                        },
                        onDismiss: {
                            viewModel.dismissError()
                        }
                    )
                } else if let homeData = viewModel.homeData {
                    HomeContentView(homeData: homeData, viewModel: viewModel)
                } else {
                    EmptyStateView {
                        Task {
                            await viewModel.loadHomeData()
                        }
                    }
                }
            }
            .navigationTitle("Home")
            .refreshable {
                await viewModel.refreshData()
            }
        }
        .task {
            await viewModel.loadHomeData()
        }
    }
}

struct HomeContentView: View {
    let homeData: HomeData
    let viewModel: HomeViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // User Welcome Section
                UserWelcomeCard(user: homeData.user)
                
                // Stats Overview
                StatsOverviewCard(stats: homeData.stats, completionPercentage: viewModel.completionPercentage)
                
                // Quick Actions
                if !homeData.quickActions.isEmpty {
                    QuickActionsCard(actions: homeData.quickActions) { action in
                        viewModel.handleQuickAction(action)
                    }
                }
                
                // Recent Activities
                if !homeData.recentActivities.isEmpty {
                    RecentActivitiesCard(activities: homeData.recentActivities) {
                        viewModel.viewAllActivities()
                    }
                }
                
                // Notifications
                if !homeData.notifications.isEmpty {
                    NotificationsCard(notifications: homeData.notifications) {
                        viewModel.viewAllNotifications()
                    }
                }
            }
            .padding()
        }
    }
}

struct UserWelcomeCard: View {
    let user: User
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.avatarURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back,")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(user.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(user.role)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct StatsOverviewCard: View {
    let stats: HomeStats
    let completionPercentage: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Overview")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(Int(completionPercentage * 100))% Complete")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: completionPercentage)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
            
            HStack(spacing: 20) {
                StatItem(title: "Total", value: stats.totalTasks, color: .blue)
                StatItem(title: "Completed", value: stats.completedTasks, color: .green)
                StatItem(title: "Pending", value: stats.pendingTasks, color: .orange)
                StatItem(title: "Deadlines", value: stats.upcomingDeadlines, color: .red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct StatItem: View {
    let title: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct QuickActionsCard: View {
    let actions: [QuickAction]
    let onActionTap: (QuickAction) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(actions) { action in
                    Button {
                        onActionTap(action)
                    } label: {
                        HStack {
                            Image(systemName: action.icon)
                                .font(.title2)
                                .foregroundColor(.blue)
                            
                            Text(action.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    .disabled(!action.isEnabled)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct RecentActivitiesCard: View {
    let activities: [Activity]
    let onViewAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Activities")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("View All") {
                    onViewAll()
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            ForEach(activities.prefix(3)) { activity in
                ActivityRow(activity: activity)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct ActivityRow: View {
    let activity: Activity
    
    var body: some View {
        HStack {
            Circle()
                .fill(colorForActivityType(activity.type))
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(activity.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Text(RelativeDateTimeFormatter().localizedString(for: activity.timestamp, relativeTo: Date()))
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
    
    private func colorForActivityType(_ type: ActivityType) -> Color {
        switch type {
        case .taskCompleted:
            return .green
        case .taskCreated, .taskUpdated:
            return .blue
        case .projectCreated, .projectUpdated:
            return .purple
        case .commentAdded:
            return .orange
        case .fileUploaded:
            return .cyan
        case .meetingScheduled:
            return .pink
        case .userJoined:
            return .mint
        case .systemUpdate:
            return .gray
        }
    }
}

struct NotificationsCard: View {
    let notifications: [Notification]
    let onViewAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Notifications")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("View All") {
                    onViewAll()
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            ForEach(notifications.prefix(3)) { notification in
                NotificationRow(notification: notification)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct NotificationRow: View {
    let notification: Notification
    
    var body: some View {
        HStack {
            Image(systemName: iconForNotificationType(notification.type))
                .foregroundColor(colorForNotificationType(notification.type))
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(notification.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(notification.message)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            if !notification.isRead {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
            }
        }
    }
    
    private func iconForNotificationType(_ type: NotificationType) -> String {
        switch type {
        case .info:
            return "info.circle"
        case .warning:
            return "exclamationmark.triangle"
        case .error:
            return "xmark.circle"
        case .success:
            return "checkmark.circle"
        }
    }
    
    private func colorForNotificationType(_ type: NotificationType) -> Color {
        switch type {
        case .info:
            return .blue
        case .warning:
            return .orange
        case .error:
            return .red
        case .success:
            return .green
        }
    }
}

struct EmptyStateView: View {
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "house")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("Welcome to Home")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Tap to load your dashboard")
                .font(.body)
                .foregroundColor(.secondary)
            
            Button("Load Dashboard") {
                onRetry()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    HomeView()
}

#Preview("With Mock Data") {
    let viewModel = HomeViewModel.preview
    return HomeView()
}
