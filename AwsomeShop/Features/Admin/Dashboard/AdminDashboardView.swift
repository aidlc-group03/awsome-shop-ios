import SwiftUI

struct AdminDashboardView: View {
    @StateObject private var viewModel = AdminDashboardViewModel()

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    statsSection
                    quickActionsSection
                    recentOrdersSection
                }
                .padding(AppSpacing.lg)
            }
        }
        .background(AppColors.bgPage)
        .task {
            await viewModel.loadData()
        }
    }

    private var navigationBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("管理后台")
                    .font(AppTypography.headline3)
                    .foregroundColor(AppColors.textPrimary)
                Text("欢迎回来，管理员")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            Spacer()
            Button {} label: {
                Image(systemName: "bell.fill")
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .background(AppColors.bgWhite)
    }

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("数据概览")
                .font(AppTypography.headline3)
                .foregroundColor(AppColors.textPrimary)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: AppSpacing.md) {
                StatCard(
                    title: "今日订单",
                    value: "\(viewModel.todayOrders)",
                    icon: "cart.fill",
                    color: AppColors.primary
                )
                StatCard(
                    title: "待发货",
                    value: "\(viewModel.pendingOrders)",
                    icon: "shippingbox.fill",
                    color: AppColors.warning
                )
                StatCard(
                    title: "商品总数",
                    value: "\(viewModel.totalProducts)",
                    icon: "bag.fill",
                    color: AppColors.success
                )
                StatCard(
                    title: "用户总数",
                    value: "\(viewModel.totalUsers)",
                    icon: "person.2.fill",
                    color: AppColors.info
                )
            }
        }
    }

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("快捷操作")
                .font(AppTypography.headline3)
                .foregroundColor(AppColors.textPrimary)

            HStack(spacing: AppSpacing.md) {
                QuickActionCard(title: "添加商品", icon: "plus.circle.fill", color: AppColors.primary) {}
                QuickActionCard(title: "发放积分", icon: "star.fill", color: AppColors.accent) {}
                QuickActionCard(title: "处理订单", icon: "checkmark.circle.fill", color: AppColors.success) {}
            }
        }
    }

    private var recentOrdersSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("最近订单")
                    .font(AppTypography.headline3)
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
                Button {} label: {
                    Text("查看全部")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.primary)
                }
            }

            VStack(spacing: 0) {
                ForEach(viewModel.recentOrders) { order in
                    RecentOrderRow(order: order)
                    if order.id != viewModel.recentOrders.last?.id {
                        Divider()
                    }
                }
            }
            .background(AppColors.bgWhite)
            .cornerRadius(CornerRadius.lg)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                Spacer()
            }

            Text(value)
                .font(AppTypography.headline2)
                .foregroundColor(AppColors.textPrimary)

            Text(title)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(AppSpacing.lg)
        .background(AppColors.bgWhite)
        .cornerRadius(CornerRadius.lg)
    }
}

struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                Text(title)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.lg)
            .background(AppColors.bgWhite)
            .cornerRadius(CornerRadius.lg)
        }
    }
}

struct RecentOrderRow: View {
    let order: Order

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter
    }()

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(order.productName)
                    .font(AppTypography.body2)
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(1)
                Text("订单号: \(order.id)")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                ASStatusBadge(title: order.status.displayName, type: order.status.statusType)
                Text(dateFormatter.string(from: order.createdAt))
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(AppSpacing.md)
    }
}

@MainActor
final class AdminDashboardViewModel: ObservableObject {
    @Published var todayOrders: Int = 0
    @Published var pendingOrders: Int = 0
    @Published var totalProducts: Int = 0
    @Published var totalUsers: Int = 0
    @Published var recentOrders: [Order] = []
    @Published var isLoading = false

    func loadData() async {
        isLoading = true
        // TODO: Call actual admin APIs
        // For now, use placeholder data
        todayOrders = 12
        pendingOrders = 5
        totalProducts = 48
        totalUsers = 156
        isLoading = false
    }
}

#Preview {
    AdminDashboardView()
}
