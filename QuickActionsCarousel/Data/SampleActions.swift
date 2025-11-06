import Foundation

/// Sample quick actions for demonstration and testing
struct SampleActions {
    static let defaultActions: [QuickAction] = [
        QuickAction(
            title: "Start Build",
            iconName: "hammer.fill",
            actionType: .build,
            action: {
                print("🔨 Starting new build...")
                // Future: Navigate to build configuration screen
            }
        ),
        
        QuickAction(
            title: "Scan Item",
            iconName: "qrcode.viewfinder",
            actionType: .scan,
            action: {
                print("📱 Opening scanner...")
                // Future: Open camera for QR/barcode scanning
            }
        ),
        
        QuickAction(
            title: "Find Teammate",
            iconName: "person.2.fill",
            actionType: .findTeammate,
            action: {
                print("👥 Opening team directory...")
                // Future: Navigate to team member search
            }
        ),
        
        QuickAction(
            title: "Log Expense",
            iconName: "dollarsign.circle.fill",
            actionType: .logExpense,
            action: {
                print("💰 Opening expense form...")
                // Future: Navigate to expense logging screen
            }
        ),
        
        QuickAction(
            title: "Create Task",
            iconName: "plus.circle.fill",
            actionType: .createTask,
            action: {
                print("✅ Creating new task...")
                // Future: Navigate to task creation screen
            }
        ),
        
        QuickAction(
            title: "View Reports",
            iconName: "chart.bar.fill",
            actionType: .viewReports,
            action: {
                print("📊 Opening reports...")
                // Future: Navigate to reports dashboard
            }
        ),
        
        QuickAction(
            title: "Settings",
            iconName: "gearshape.fill",
            actionType: .settings,
            action: {
                print("⚙️ Opening settings...")
                // Future: Navigate to app settings
            }
        ),
        
        QuickAction(
            title: "Help",
            iconName: "questionmark.circle.fill",
            actionType: .help,
            action: {
                print("❓ Opening help...")
                // Future: Navigate to help and support
            }
        )
    ]
    
    /// Subset of actions for testing with fewer items
    static let limitedActions: [QuickAction] = Array(defaultActions.prefix(4))
    
    /// Actions for testing accessibility features
    static let accessibilityTestActions: [QuickAction] = [
        QuickAction(
            title: "Very Long Action Title That Wraps",
            iconName: "text.alignleft",
            actionType: .createTask,
            action: {
                print("Testing long title accessibility")
            }
        ),
        
        QuickAction(
            title: "Short",
            iconName: "s.circle.fill",
            actionType: .help,
            action: {
                print("Testing short title accessibility")
            }
        )
    ]
}

