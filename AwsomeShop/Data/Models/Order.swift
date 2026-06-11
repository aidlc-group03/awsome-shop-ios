import Foundation

struct Order: Codable, Identifiable {
    let id: Int64
    let userId: Int64
    let productId: Int64
    let productName: String
    let productImageUrl: String?
    let points: Int
    let status: OrderStatus
    let addressSnapshot: AddressSnapshot?
    let trackingNumber: String?
    let createdAt: Date
    let shippedAt: Date?
    let completedAt: Date?
}

enum OrderStatus: String, Codable, CaseIterable {
    case pending = "PENDING"
    case shipped = "SHIPPED"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"

    var displayName: String {
        switch self {
        case .pending: return "待发货"
        case .shipped: return "已发货"
        case .completed: return "已完成"
        case .cancelled: return "已取消"
        }
    }

    var statusType: ASStatusType {
        switch self {
        case .pending: return .pending
        case .shipped: return .shipped
        case .completed: return .completed
        case .cancelled: return .cancelled
        }
    }
}

struct AddressSnapshot: Codable {
    let name: String
    let phone: String
    let region: String
    let detail: String

    var fullAddress: String {
        "\(region) \(detail)"
    }
}
