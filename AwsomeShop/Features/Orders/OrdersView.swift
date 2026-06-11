import SwiftUI

struct OrdersView: View {
    @StateObject private var viewModel = OrdersViewModel()
    @EnvironmentObject var router: AppRouter

    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            statusTabs
            orderList
        }
        .background(AppColors.bgPage)
        .task {
            await viewModel.loadOrders()
        }
    }

    private var navigationBar: some View {
        HStack {
            Text("我的订单")
                .font(AppTypography.headline3)
                .foregroundColor(AppColors.textPrimary)
            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .background(AppColors.bgWhite)
    }

    private var statusTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ASChip(title: "全部", isSelected: viewModel.selectedStatus == nil) {
                    Task { await viewModel.selectStatus(nil) }
                }

                ForEach(OrderStatus.allCases, id: \.self) { status in
                    ASChip(title: status.displayName, isSelected: viewModel.selectedStatus == status) {
                        Task { await viewModel.selectStatus(status) }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
        }
        .background(AppColors.bgWhite)
    }

    private var orderList: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 100)
            } else if viewModel.orders.isEmpty {
                emptyState
            } else {
                LazyVStack(spacing: AppSpacing.md) {
                    ForEach(viewModel.orders) { order in
                        OrderCard(order: order) {
                            router.push(.orderDetail(orderId: order.id))
                        }
                    }
                }
                .padding(AppSpacing.lg)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "list.bullet.rectangle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.textDisabled)

            Text("暂无订单")
                .font(AppTypography.body1)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.top, 100)
    }
}

struct OrderCard: View {
    let order: Order
    let onTap: () -> Void

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                HStack {
                    Text("订单号: \(order.id)")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                    ASStatusBadge(title: order.status.displayName, type: order.status.statusType)
                }

                HStack(spacing: AppSpacing.md) {
                    productImage

                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text(order.productName)
                            .font(AppTypography.body2)
                            .foregroundColor(AppColors.textPrimary)
                            .lineLimit(2)

                        Text("\(order.points) 积分")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(AppColors.primary)
                    }

                    Spacer()
                }

                HStack {
                    Text(dateFormatter.string(from: order.createdAt))
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)

                    Spacer()

                    Text("查看详情")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.primary)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.primary)
                }
            }
            .padding(AppSpacing.lg)
            .background(AppColors.bgWhite)
            .cornerRadius(CornerRadius.lg)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var productImage: some View {
        ZStack {
            AppColors.primaryBg

            if let imageUrl = order.productImageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    default:
                        Image(systemName: "bag.fill")
                            .foregroundColor(AppColors.primary.opacity(0.3))
                    }
                }
            } else {
                Image(systemName: "bag.fill")
                    .foregroundColor(AppColors.primary.opacity(0.3))
            }
        }
        .frame(width: 80, height: 80)
        .cornerRadius(CornerRadius.md)
    }
}

#Preview {
    OrdersView()
        .environmentObject(AppRouter())
}
