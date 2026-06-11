import SwiftUI

struct RedemptionSuccessView: View {
    let orderId: Int64
    @EnvironmentObject var router: AppRouter

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    var body: some View {
        VStack {
            Spacer()

            ASCard {
                VStack(spacing: AppSpacing.xxl) {
                    successIcon

                    VStack(spacing: AppSpacing.sm) {
                        Text("兑换成功!")
                            .font(AppTypography.headline2)
                            .foregroundColor(AppColors.textPrimary)

                        Text("您的订单已提交，请等待发货")
                            .font(AppTypography.body2)
                            .foregroundColor(AppColors.textSecondary)
                    }

                    Divider()

                    orderInfo

                    Divider()

                    buttonGroup
                }
            }
            .padding(.horizontal, AppSpacing.xxxl)

            Spacer()
        }
        .background(AppColors.bgPage)
        .navigationBarBackButtonHidden(true)
    }

    private var successIcon: some View {
        ZStack {
            Circle()
                .fill(AppColors.chipGreenBg)
                .frame(width: 80, height: 80)

            Image(systemName: "checkmark")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(AppColors.success)
        }
    }

    private var orderInfo: some View {
        VStack(spacing: AppSpacing.md) {
            infoRow(title: "订单编号", value: "\(orderId)")
            infoRow(title: "下单时间", value: dateFormatter.string(from: Date()))
        }
        .padding(AppSpacing.lg)
        .background(AppColors.bgPage)
        .cornerRadius(CornerRadius.md)
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(AppTypography.body2)
                .foregroundColor(AppColors.textSecondary)
            Spacer()
            Text(value)
                .font(AppTypography.body2)
                .foregroundColor(AppColors.textPrimary)
        }
    }

    private var buttonGroup: some View {
        VStack(spacing: AppSpacing.md) {
            ASButton("查看订单") {
                router.popToRoot()
                router.push(.orderDetail(orderId: orderId))
            }

            ASButton("继续逛逛", style: .outline) {
                router.popToRoot()
            }
        }
    }
}

#Preview {
    RedemptionSuccessView(orderId: 12345)
        .environmentObject(AppRouter())
}
