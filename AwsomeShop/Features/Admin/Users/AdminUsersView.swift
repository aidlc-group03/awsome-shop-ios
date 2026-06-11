import SwiftUI

struct AdminUsersView: View {
    @StateObject private var viewModel = AdminUsersViewModel()
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView {
                VStack(spacing: AppSpacing.md) {
                    searchBar
                    userList
                    logoutButton
                }
                .padding(AppSpacing.lg)
            }
        }
        .background(AppColors.bgPage)
    }

    private var navigationBar: some View {
        HStack {
            Text("用户管理")
                .font(AppTypography.headline3)
                .foregroundColor(AppColors.textPrimary)

            Spacer()

            Button {} label: {
                HStack(spacing: 4) {
                    Image(systemName: "plus")
                    Text("添加")
                }
                .font(AppTypography.body2)
                .foregroundColor(AppColors.textWhite)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(AppColors.primary)
                .cornerRadius(CornerRadius.md)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .background(AppColors.bgWhite)
    }

    private var searchBar: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textSecondary)

            TextField("搜索用户", text: $viewModel.searchText)
                .font(AppTypography.body2)
        }
        .padding(AppSpacing.md)
        .background(AppColors.bgWhite)
        .cornerRadius(CornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .stroke(AppColors.border, lineWidth: 1)
        )
    }

    private var userList: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.users, id: \.username) { user in
                UserRow(user: user) {
                    // Adjust points
                }
                if user.username != viewModel.users.last?.username {
                    Divider()
                        .padding(.leading, 60)
                }
            }
        }
        .background(AppColors.bgWhite)
        .cornerRadius(CornerRadius.lg)
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
        .padding(.top, AppSpacing.lg)
    }
}

struct UserRow: View {
    let user: UserInfo
    let onAdjustPoints: () -> Void

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Circle()
                .fill(AppColors.primaryBg)
                .frame(width: 44, height: 44)
                .overlay(
                    Text(String(user.displayName.prefix(1)))
                        .font(AppTypography.headline3)
                        .foregroundColor(AppColors.primary)
                )

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: AppSpacing.sm) {
                    Text(user.displayName)
                        .font(AppTypography.body1)
                        .foregroundColor(AppColors.textPrimary)

                    ASStatusBadge(
                        title: user.role == .admin ? "管理员" : "员工",
                        type: user.role == .admin ? .info : .completed
                    )
                }

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

                if let points = user.points {
                    Text("积分: \(points)")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.accent)
                }
            }

            Spacer()

            Button(action: onAdjustPoints) {
                Image(systemName: "star.fill")
                    .foregroundColor(AppColors.accent)
            }
        }
        .padding(AppSpacing.md)
    }
}

struct UserInfo: Identifiable {
    var id: String { username }
    let username: String
    let displayName: String
    let role: UserRole
    let employeeId: String?
    let department: String?
    let points: Int?
}

@MainActor
final class AdminUsersViewModel: ObservableObject {
    @Published var users: [UserInfo] = []
    @Published var searchText = ""
    @Published var isLoading = false

    init() {
        // Mock data for now
        users = [
            UserInfo(username: "admin", displayName: "管理员", role: .admin, employeeId: "EMP001", department: "人力资源部", points: nil),
            UserInfo(username: "employee", displayName: "李明", role: .employee, employeeId: "EMP002", department: "技术部", points: 2580),
            UserInfo(username: "zhangsan", displayName: "张三", role: .employee, employeeId: "EMP003", department: "市场部", points: 1850),
            UserInfo(username: "lisi", displayName: "李四", role: .employee, employeeId: "EMP004", department: "财务部", points: 3200),
        ]
    }
}

#Preview {
    AdminUsersView()
        .environmentObject(AuthManager.shared)
}
