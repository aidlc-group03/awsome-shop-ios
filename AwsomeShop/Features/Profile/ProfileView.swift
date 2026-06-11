import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var router: AppRouter

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    userCard
                    menuSection
                    logoutButton
                }
                .padding(AppSpacing.lg)
            }
        }
        .background(AppColors.bgPage)
    }

    private var navigationBar: some View {
        HStack {
            Text("个人中心")
                .font(AppTypography.headline3)
                .foregroundColor(AppColors.textPrimary)
            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .background(AppColors.bgWhite)
    }

    private var userCard: some View {
        HStack(spacing: AppSpacing.lg) {
            Circle()
                .fill(AppColors.primary)
                .frame(width: 60, height: 60)
                .overlay(
                    Text(String(authManager.currentUser?.displayName.prefix(1) ?? "U"))
                        .font(AppTypography.headline2)
                        .foregroundColor(AppColors.textWhite)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(authManager.currentUser?.displayName ?? "用户")
                    .font(AppTypography.headline3)
                    .foregroundColor(AppColors.textPrimary)

                if let user = authManager.currentUser {
                    HStack(spacing: AppSpacing.sm) {
                        if let employeeId = user.employeeId {
                            Text(employeeId)
                        }
                        if let department = user.department {
                            Text("·")
                            Text(department)
                        }
                    }
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(AppSpacing.lg)
        .background(AppColors.bgWhite)
        .cornerRadius(CornerRadius.lg)
    }

    private var menuSection: some View {
        VStack(spacing: 0) {
            menuItem(icon: "list.bullet.rectangle", title: "我的订单") {
            }

            Divider().padding(.leading, 52)

            menuItem(icon: "location", title: "收货地址") {
            }

            Divider().padding(.leading, 52)

            menuItem(icon: "star", title: "积分明细") {
                router.push(.pointsHistory)
            }

            Divider().padding(.leading, 52)

            menuItem(icon: "questionmark.circle", title: "帮助中心") {}

            Divider().padding(.leading, 52)

            menuItem(icon: "info.circle", title: "关于我们") {}
        }
        .background(AppColors.bgWhite)
        .cornerRadius(CornerRadius.lg)
    }

    private func menuItem(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.textSecondary)
                    .frame(width: 24)

                Text(title)
                    .font(AppTypography.body1)
                    .foregroundColor(AppColors.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(AppSpacing.lg)
        }
    }

    private var logoutButton: some View {
        Button {
            authManager.logout()
        } label: {
            Text("退出登录")
                .font(AppTypography.body1)
                .foregroundColor(AppColors.error)
                .frame(maxWidth: .infinity)
                .padding(AppSpacing.lg)
                .background(AppColors.bgWhite)
                .cornerRadius(CornerRadius.lg)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthManager.shared)
        .environmentObject(AppRouter())
}
