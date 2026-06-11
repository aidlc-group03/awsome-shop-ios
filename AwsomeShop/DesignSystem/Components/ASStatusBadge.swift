import SwiftUI

enum ASStatusType {
    case pending
    case shipped
    case completed
    case cancelled
    case info

    var backgroundColor: Color {
        switch self {
        case .pending: return AppColors.chipOrangeBg
        case .shipped: return AppColors.chipBlueBg
        case .completed: return AppColors.chipGreenBg
        case .cancelled: return AppColors.chipRedBg
        case .info: return AppColors.chipBlueBg
        }
    }

    var textColor: Color {
        switch self {
        case .pending: return AppColors.chipOrangeText
        case .shipped: return AppColors.chipBlueText
        case .completed: return AppColors.chipGreenText
        case .cancelled: return AppColors.chipRedText
        case .info: return AppColors.chipBlueText
        }
    }
}

struct ASStatusBadge: View {
    let title: String
    let type: ASStatusType

    var body: some View {
        Text(title)
            .font(AppTypography.caption)
            .foregroundColor(type.textColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(type.backgroundColor)
            .cornerRadius(CornerRadius.sm)
    }
}

#Preview {
    HStack(spacing: 8) {
        ASStatusBadge(title: "待发货", type: .pending)
        ASStatusBadge(title: "已发货", type: .shipped)
        ASStatusBadge(title: "已完成", type: .completed)
        ASStatusBadge(title: "已取消", type: .cancelled)
    }
    .padding()
}
