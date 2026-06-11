import SwiftUI

struct PointsBanner: View {
    let balance: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("我的积分")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textWhite.opacity(0.8))

                    Text("\(balance)")
                        .font(AppTypography.headline1)
                        .foregroundColor(AppColors.textWhite)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.textWhite.opacity(0.8))
            }
            .padding(AppSpacing.xl)
            .background(
                LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(CornerRadius.lg)
        }
    }
}

#Preview {
    PointsBanner(balance: 12580) {}
        .padding()
}
