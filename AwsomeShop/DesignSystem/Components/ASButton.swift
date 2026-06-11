import SwiftUI

enum ASButtonStyle {
    case primary
    case secondary
    case outline
    case text
}

enum ASButtonSize {
    case large
    case medium
    case small

    var height: CGFloat {
        switch self {
        case .large: return 48
        case .medium: return 40
        case .small: return 32
        }
    }

    var font: Font {
        switch self {
        case .large: return AppTypography.button
        case .medium: return Font.system(size: 14, weight: .semibold)
        case .small: return Font.system(size: 12, weight: .semibold)
        }
    }

    var padding: CGFloat {
        switch self {
        case .large: return 24
        case .medium: return 16
        case .small: return 12
        }
    }
}

struct ASButton: View {
    let title: String
    let style: ASButtonStyle
    let size: ASButtonSize
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void

    init(
        _ title: String,
        style: ASButtonStyle = .primary,
        size: ASButtonSize = .large,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .scaleEffect(0.8)
                }
                Text(title)
                    .font(size.font)
            }
            .frame(maxWidth: .infinity)
            .frame(height: size.height)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(CornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .stroke(borderColor, lineWidth: style == .outline ? 1 : 0)
            )
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.5 : 1)
    }

    private var backgroundColor: Color {
        switch style {
        case .primary: return AppColors.primary
        case .secondary: return AppColors.primaryBg
        case .outline, .text: return .clear
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return AppColors.textWhite
        case .secondary, .outline, .text: return AppColors.primary
        }
    }

    private var borderColor: Color {
        style == .outline ? AppColors.border : .clear
    }
}

#Preview {
    VStack(spacing: 16) {
        ASButton("主要按钮", style: .primary) {}
        ASButton("次要按钮", style: .secondary) {}
        ASButton("边框按钮", style: .outline) {}
        ASButton("文字按钮", style: .text) {}
        ASButton("加载中", isLoading: true) {}
        ASButton("禁用", isDisabled: true) {}
    }
    .padding()
}
