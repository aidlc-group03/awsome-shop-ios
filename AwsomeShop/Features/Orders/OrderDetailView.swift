import SwiftUI

struct OrderDetailView: View {
    let orderId: Int64
    @StateObject private var viewModel: OrderDetailViewModel
    @Environment(\.dismiss) var dismiss

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    init(orderId: Int64) {
        self.orderId = orderId
        _viewModel = StateObject(wrappedValue: OrderDetailViewModel(orderId: orderId))
    }

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            if viewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if let order = viewModel.order {
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        statusCard(order)
                        productCard(order)
                        pointsCard(order)
                        if let address = order.addressSnapshot {
                            deliveryCard(address)
                        }
                        orderInfoCard(order)
                    }
                    .padding(AppSpacing.lg)
                }
            }
        }
        .background(AppColors.bgPage)
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.loadOrder()
        }
    }

    private var navigationBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(AppColors.textPrimary)
            }

            Spacer()

            Text("订单详情")
                .font(AppTypography.headline3)
                .foregroundColor(AppColors.textPrimary)

            Spacer()

            Color.clear.frame(width: 24)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .background(AppColors.bgWhite)
    }

    private func statusCard(_ order: Order) -> some View {
        ASCard {
            VStack(spacing: AppSpacing.lg) {
                HStack {
                    Text(order.status.displayName)
                        .font(AppTypography.headline2)
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                    ASStatusBadge(title: order.status.displayName, type: order.status.statusType)
                }

                statusTimeline(order)

                if let trackingNumber = order.trackingNumber, !trackingNumber.isEmpty {
                    HStack {
                        Text("物流单号")
                            .font(AppTypography.body2)
                            .foregroundColor(AppColors.textSecondary)
                        Spacer()
                        Text(trackingNumber)
                            .font(AppTypography.body2)
                            .foregroundColor(AppColors.textPrimary)
                        Button {
                            UIPasteboard.general.string = trackingNumber
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .font(.system(size: 14))
                                .foregroundColor(AppColors.primary)
                        }
                    }
                }
            }
        }
    }

    private func statusTimeline(_ order: Order) -> some View {
        HStack(spacing: 0) {
            timelineItem(title: "已下单", isCompleted: true, isFirst: true)
            timelineLine(isCompleted: order.status != .pending)
            timelineItem(title: "已发货", isCompleted: order.status == .shipped || order.status == .completed, isFirst: false)
            timelineLine(isCompleted: order.status == .completed)
            timelineItem(title: "已完成", isCompleted: order.status == .completed, isFirst: false)
        }
    }

    private func timelineItem(title: String, isCompleted: Bool, isFirst: Bool) -> some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(isCompleted ? AppColors.success : AppColors.borderLight)
                    .frame(width: 20, height: 20)

                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(AppColors.textWhite)
                }
            }

            Text(title)
                .font(AppTypography.caption)
                .foregroundColor(isCompleted ? AppColors.success : AppColors.textSecondary)
        }
    }

    private func timelineLine(isCompleted: Bool) -> some View {
        Rectangle()
            .fill(isCompleted ? AppColors.success : AppColors.borderLight)
            .frame(height: 2)
            .frame(maxWidth: .infinity)
            .offset(y: -10)
    }

    private func productCard(_ order: Order) -> some View {
        ASCard {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text("商品信息")
                    .font(AppTypography.headline3)
                    .foregroundColor(AppColors.textPrimary)

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
                    .frame(width: 80, height: 80)
                    .cornerRadius(CornerRadius.md)

                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text(order.productName)
                            .font(AppTypography.body1)
                            .foregroundColor(AppColors.textPrimary)
                            .lineLimit(2)

                        Text("\(order.points) 积分")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.primary)
                    }

                    Spacer()
                }
            }
        }
    }

    private func pointsCard(_ order: Order) -> some View {
        ASCard {
            VStack(spacing: AppSpacing.md) {
                HStack {
                    Text("积分信息")
                        .font(AppTypography.headline3)
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                }

                HStack {
                    Text("扣减积分")
                        .font(AppTypography.body2)
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                    Text("-\(order.points) 积分")
                        .font(AppTypography.body2)
                        .foregroundColor(AppColors.error)
                }
            }
        }
    }

    private func deliveryCard(_ address: AddressSnapshot) -> some View {
        ASCard {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text("收货信息")
                    .font(AppTypography.headline3)
                    .foregroundColor(AppColors.textPrimary)

                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    HStack {
                        Text(address.name)
                            .font(AppTypography.body1)
                            .foregroundColor(AppColors.textPrimary)
                        Text(address.phone)
                            .font(AppTypography.body2)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    Text(address.fullAddress)
                        .font(AppTypography.body2)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
    }

    private func orderInfoCard(_ order: Order) -> some View {
        ASCard {
            VStack(spacing: AppSpacing.md) {
                HStack {
                    Text("订单信息")
                        .font(AppTypography.headline3)
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                }

                infoRow(title: "订单编号", value: "\(order.id)")
                infoRow(title: "下单时间", value: dateFormatter.string(from: order.createdAt))

                if let shippedAt = order.shippedAt {
                    infoRow(title: "发货时间", value: dateFormatter.string(from: shippedAt))
                }

                if let completedAt = order.completedAt {
                    infoRow(title: "完成时间", value: dateFormatter.string(from: completedAt))
                }
            }
        }
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
}

@MainActor
final class OrderDetailViewModel: ObservableObject {
    @Published var order: Order?
    @Published var isLoading = false

    private let orderId: Int64
    private let orderRepository: OrderRepositoryProtocol

    init(orderId: Int64, orderRepository: OrderRepositoryProtocol = OrderRepository()) {
        self.orderId = orderId
        self.orderRepository = orderRepository
    }

    func loadOrder() async {
        isLoading = true

        do {
            order = try await orderRepository.getOrderDetail(id: orderId)
        } catch {
            print("Failed to load order: \(error)")
        }

        isLoading = false
    }
}

#Preview {
    NavigationStack {
        OrderDetailView(orderId: 1)
    }
}
