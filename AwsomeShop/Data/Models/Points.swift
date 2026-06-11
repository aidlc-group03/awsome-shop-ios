import Foundation

struct PointsBalance: Codable {
    let userId: Int64
    let balance: Int
    let totalEarned: Int
    let totalUsed: Int
    let redemptionCount: Int
}

struct PointsTransaction: Codable, Identifiable {
    let id: Int64
    let type: TransactionType
    let amount: Int
    let balanceAfter: Int
    let description: String
    let operatorId: Int64?
    let relatedOrderId: Int64?
    let createdAt: Date
}

enum TransactionType: String, Codable {
    case redemption = "REDEMPTION"
    case performance = "PERFORMANCE"
    case seniority = "SENIORITY"
    case holiday = "HOLIDAY"
    case special = "SPECIAL"
    case adminAdd = "ADMIN_ADD"
    case adminDeduct = "ADMIN_DEDUCT"
    case refund = "REFUND"

    var displayName: String {
        switch self {
        case .redemption: return "积分兑换"
        case .performance: return "绩效奖励"
        case .seniority: return "工龄奖励"
        case .holiday: return "节日奖励"
        case .special: return "特别奖励"
        case .adminAdd: return "管理员发放"
        case .adminDeduct: return "管理员扣除"
        case .refund: return "兑换退还"
        }
    }

    var icon: String {
        switch self {
        case .redemption: return "bag.fill"
        case .performance: return "chart.line.uptrend.xyaxis"
        case .seniority: return "calendar"
        case .holiday: return "gift.fill"
        case .special: return "star.fill"
        case .adminAdd: return "plus.circle.fill"
        case .adminDeduct: return "minus.circle.fill"
        case .refund: return "arrow.uturn.backward.circle.fill"
        }
    }

    var isEarning: Bool {
        switch self {
        case .redemption, .adminDeduct: return false
        default: return true
        }
    }
}
