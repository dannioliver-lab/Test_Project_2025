import Foundation

// MARK: - Activity Model
struct Activity: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let type: ActivityType
    let timestamp: Date
    let status: ActivityStatus
    let metadata: ActivityMetadata?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case type
        case timestamp
        case status
        case metadata
    }
}

// MARK: - Activity Type
enum ActivityType: String, Codable, CaseIterable {
    case taskCreated = "task_created"
    case taskCompleted = "task_completed"
    case taskUpdated = "task_updated"
    case projectCreated = "project_created"
    case projectUpdated = "project_updated"
    case commentAdded = "comment_added"
    case fileUploaded = "file_uploaded"
    case meetingScheduled = "meeting_scheduled"
    case userJoined = "user_joined"
    case systemUpdate = "system_update"
}

// MARK: - Activity Status
enum ActivityStatus: String, Codable, CaseIterable {
    case pending = "pending"
    case inProgress = "in_progress"
    case completed = "completed"
    case cancelled = "cancelled"
    case failed = "failed"
}

// MARK: - Activity Metadata
struct ActivityMetadata: Codable {
    let projectId: String?
    let taskId: String?
    let userId: String?
    let fileSize: Int?
    let fileName: String?
    let additionalInfo: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case projectId = "project_id"
        case taskId = "task_id"
        case userId = "user_id"
        case fileSize = "file_size"
        case fileName = "file_name"
        case additionalInfo = "additional_info"
    }
}
