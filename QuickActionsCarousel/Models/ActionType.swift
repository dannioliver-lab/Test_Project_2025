import Foundation

/// Defines the different types of quick actions available
enum ActionType: String, CaseIterable {
    case build = "build"
    case scan = "scan"
    case findTeammate = "find_teammate"
    case logExpense = "log_expense"
    case createTask = "create_task"
    case viewReports = "view_reports"
    case settings = "settings"
    case help = "help"
    
    /// Human-readable description of the action type
    var description: String {
        switch self {
        case .build:
            return "Start a new build process"
        case .scan:
            return "Scan an item or document"
        case .findTeammate:
            return "Find and contact a teammate"
        case .logExpense:
            return "Log a new expense"
        case .createTask:
            return "Create a new task"
        case .viewReports:
            return "View reports and analytics"
        case .settings:
            return "Open app settings"
        case .help:
            return "Get help and support"
        }
    }
    
    /// Accessibility label for VoiceOver
    var accessibilityLabel: String {
        switch self {
        case .build:
            return "Start New Build"
        case .scan:
            return "Scan Item"
        case .findTeammate:
            return "Find Teammate"
        case .logExpense:
            return "Log Expense"
        case .createTask:
            return "Create Task"
        case .viewReports:
            return "View Reports"
        case .settings:
            return "Settings"
        case .help:
            return "Help"
        }
    }
}

