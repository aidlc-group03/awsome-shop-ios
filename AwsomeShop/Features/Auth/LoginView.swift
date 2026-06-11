import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                brandSection
                    .frame(height: geometry.size.height * 0.35)

                loginFormSection
                    .frame(maxHeight: .infinity)
            }
        }
        .ignoresSafeArea()
    }

    private var brandSection: some View {
        ZStack {
            LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(spacing: AppSpacing.lg) {
                Image(systemName: "gift.fill")
                    .font(.system(size: 56))
                    .foregroundColor(AppColors.textWhite)

                Text("AWSome Shop")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppColors.textWhite)

                Text("员工积分兑换平台")
                    .font(AppTypography.body1)
                    .foregroundColor(AppColors.textWhite.opacity(0.8))
            }
        }
    }

    private var loginFormSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xl) {
            Text("欢迎回来")
                .font(AppTypography.headline2)
                .foregroundColor(AppColors.textPrimary)

            Text("登录您的账户以继续")
                .font(AppTypography.body2)
                .foregroundColor(AppColors.textSecondary)

            VStack(spacing: AppSpacing.lg) {
                ASTextField(
                    placeholder: "用户名",
                    text: $viewModel.username,
                    icon: "person"
                )

                ASTextField(
                    placeholder: "密码",
                    text: $viewModel.password,
                    icon: "lock",
                    isSecure: true
                )
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.error)
            }

            ASButton(
                "登 录",
                isLoading: viewModel.isLoading,
                isDisabled: !viewModel.isValid
            ) {
                Task {
                    await viewModel.login()
                }
            }

            Button {
            } label: {
                Text("忘记密码？")
                    .font(AppTypography.body2)
                    .foregroundColor(AppColors.primary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, AppSpacing.xxl)
        .padding(.top, 40)
        .background(
            AppColors.bgWhite
                .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
        )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    LoginView()
}
