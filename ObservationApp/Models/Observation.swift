import Foundation

enum ObservationCategory: String, CaseIterable, Codable {
    case flora = "Flora"
    case fauna = "Fauna"
    case weather = "Weather"
    case geology = "Geology"
    case other = "Other"
}

enum ObservationStatus: String, CaseIterable, Codable {
    case pending = "Pending"
    case verified = "Verified"
    case rejected = "Rejected"
}

struct Observation: Codable, Identifiable {
    let id: UUID
    let title: String
    let description: String
    let category: ObservationCategory
    let status: ObservationStatus
    let createdAt: Date
    let location: String?
    let imageURL: String?
    let userID: UUID
    
    init(id: UUID = UUID(), title: String, description: String, category: ObservationCategory, status: ObservationStatus = .pending, createdAt: Date = Date(), location: String? = nil, imageURL: String? = nil, userID: UUID) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.status = status
        self.createdAt = createdAt
        self.location = location
        self.imageURL = imageURL
        self.userID = userID
    }
}
