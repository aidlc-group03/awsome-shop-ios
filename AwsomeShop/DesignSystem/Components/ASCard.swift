import SwiftUI

struct ASCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppSpacing.xxl)
            .background(AppColors.bgWhite)
            .cornerRadius(CornerRadius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .stroke(AppColors.borderLight, lineWidth: 1)
            )
    }
}

#Preview {
    ASCard {
        VStack(alignment: .leading, spacing: 8) {
            Text("卡片标题")
                .font(AppTypography.headline3)
            Text("卡片内容描述")
                .font(AppTypography.body2)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding()
    .background(AppColors.bgPage)
}
