import Foundation

struct User: Codable, Identifiable {
    let id: Int64
    let username: String
    let displayName: String
    let role: UserRole
    let employeeId: String?
    let department: String?
    let title: String?
    let status: UserStatus?

    enum CodingKeys: String, CodingKey {
        case id, username, displayName, role, employeeId, department, title, status
    }
}

enum UserRole: String, Codable {
    case employee = "EMPLOYEE"
    case admin = "ADMIN"
}

enum UserStatus: String, Codable {
    case active = "ACTIVE"
    case locked = "LOCKED"
}
