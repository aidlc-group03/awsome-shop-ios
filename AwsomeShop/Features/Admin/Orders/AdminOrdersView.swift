import SwiftUI

struct AdminOrdersView: View {
    @StateObject private var viewModel = AdminOrdersViewModel()

    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            statusTabs

            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.top, 50)
                } else if viewModel.orders.isEmpty {
                    emptyState
                } else {
                    orderList
                }
            }
        }
        .background(AppColors.bgPage)
        .task {
            await viewModel.loadOrders()
        }
    }

    private var navigationBar: some View {
        HStack {
            Text("订单管理")
                .font(AppTypography.headline3)
                .foregroundColor(AppColors.textPrimary)

            Spacer()

            Button {} label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundColor(AppColors.textSecondary)
            }
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
        LazyVStack(spacing: AppSpacing.md) {
            ForEach(viewModel.orders) { order in
                AdminOrderRow(order: order) {
                    // Ship order action
                }
            }
        }
        .padding(AppSpacing.lg)
    }

    private var emptyState: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "list.clipboard")
                .font(.system(size: 60))
                .foregroundColor(AppColors.textDisabled)

            Text("暂无订单")
                .font(AppTypography.body1)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.top, 100)
    }
}

struct AdminOrderRow: View {
    let order: Order
    let onShip: () -> Void

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("订单号: \(order.id)")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
                Spacer()
                ASStatusBadge(title: order.status.displayName, type: order.status.statusType)
            }

            HStack(spacing: AppSpacing.md) {
                ZStack {
                    AppColors.primaryBg
                    if let imageUrl = order.productImageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            if case .success(let image) = phase {
                                image.resizable().aspectRatio(contentMode: .fit)
                            }
                        }
                    } else {
                        Image(systemName: "bag.fill")
                            .foregroundColor(AppColors.primary.opacity(0.3))
                    }
                }
                .frame(width: 60, height: 60)
                .cornerRadius(CornerRadius.md)

                VStack(alignment: .leading, spacing: 4) {
                    Text(order.productName)
                        .font(AppTypography.body2)
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)

                    Text("\(order.points) 积分")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.primary)

                    Text(dateFormatter.string(from: order.createdAt))
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                }

                Spacer()
            }

            if let address = order.addressSnapshot {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: AppSpacing.sm) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 12))
                        Text("\(address.name) \(address.phone)")
                            .font(AppTypography.caption)
                    }
                    .foregroundColor(AppColors.textSecondary)

                    Text(address.fullAddress)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(1)
                }
                .padding(.top, AppSpacing.xs)
            }

            if order.status == .pending {
                HStack {
                    Spacer()
                    Button(action: onShip) {
                        HStack(spacing: 4) {
                            Image(systemName: "shippingbox.fill")
                            Text("发货")
                        }
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textWhite)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.sm)
                        .background(AppColors.primary)
                        .cornerRadius(CornerRadius.md)
                    }
                }
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.bgWhite)
        .cornerRadius(CornerRadius.lg)
    }
}

@MainActor
final class AdminOrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var selectedStatus: OrderStatus? = nil
    @Published var isLoading = false

    private let orderRepository: OrderRepositoryProtocol

    init(orderRepository: OrderRepositoryProtocol = OrderRepository()) {
        self.orderRepository = orderRepository
    }

    func loadOrders() async {
        isLoading = true

        do {
            let response = try await orderRepository.getOrders(page: 1, size: 50, status: selectedStatus)
            orders = response.records
        } catch {
            print("Failed to load orders: \(error)")
        }

        isLoading = false
    }

    func selectStatus(_ status: OrderStatus?) async {
        selectedStatus = status
        await loadOrders()
    }
}

#Preview {
    AdminOrdersView()
}
