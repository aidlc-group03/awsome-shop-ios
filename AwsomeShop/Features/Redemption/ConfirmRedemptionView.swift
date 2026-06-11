import SwiftUI

struct ConfirmRedemptionView: View {
    let productId: Int64
    @StateObject private var viewModel: ConfirmRedemptionViewModel
    @EnvironmentObject var router: AppRouter
    @Environment(\.dismiss) var dismiss

    init(productId: Int64) {
        self.productId = productId
        _viewModel = StateObject(wrappedValue: ConfirmRedemptionViewModel(productId: productId))
    }

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            if viewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if let product = viewModel.product {
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        productCard(product)
                        pointsCard(product)
                        balanceBar(product)
                        deliveryCard
                        notesSection
                    }
                    .padding(AppSpacing.lg)
                }

                buttonBar(product)
            }
        }
        .background(AppColors.bgPage)
        .navigationBarBackButtonHidden(true)
        .alert("兑换失败", isPresented: $viewModel.showError) {
            Button("确定") {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .task {
            await viewModel.loadData()
        }
    }

    private var navigationBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(AppColors.textPrimary)
            }

            Spacer()

            Text("确认兑换")
                .font(AppTypography.headline3)
                .foregroundColor(AppColors.textPrimary)

            Spacer()

            Color.clear.frame(width: 24)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .background(AppColors.bgWhite)
    }

    private func productCard(_ product: Product) -> some View {
        ASCard {
            HStack(spacing: AppSpacing.lg) {
                ZStack {
                    AppColors.primaryBg
                    if let imageUrl = product.imageUrl, let url = URL(string: imageUrl) {
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
                    Text(product.name)
                        .font(AppTypography.body1)
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(2)

                    Text("\(product.pointsPrice) 积分")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.primary)
                }

                Spacer()
            }
        }
    }

    private func pointsCard(_ product: Product) -> some View {
        ASCard {
            VStack(spacing: AppSpacing.md) {
                HStack {
                    Text("积分扣减")
                        .font(AppTypography.headline3)
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                }

                Divider()

                HStack {
                    Text("当前余额")
                        .font(AppTypography.body2)
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                    Text("\(viewModel.currentBalance) 积分")
                        .font(AppTypography.body2)
                        .foregroundColor(AppColors.textPrimary)
                }

                HStack {
                    Text("扣减积分")
                        .font(AppTypography.body2)
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                    Text("-\(product.pointsPrice) 积分")
                        .font(AppTypography.body2)
                        .foregroundColor(AppColors.error)
                }

                Divider()

                HStack {
                    Text("剩余积分")
                        .font(AppTypography.body1)
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                    Text("\(viewModel.currentBalance - product.pointsPrice) 积分")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.primary)
                }
            }
        }
    }

    private func balanceBar(_ product: Product) -> some View {
        HStack {
            Image(systemName: "info.circle")
                .foregroundColor(AppColors.primary)
            Text("扣减后余额: \(viewModel.currentBalance - product.pointsPrice) 积分")
                .font(AppTypography.body2)
                .foregroundColor(AppColors.primary)
            Spacer()
        }
        .padding(AppSpacing.md)
        .background(AppColors.primaryBg)
        .cornerRadius(CornerRadius.md)
    }

    private var deliveryCard: some View {
        ASCard {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                HStack {
                    Text("收货信息")
                        .font(AppTypography.headline3)
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                    Button {
                        router.push(.deliveryInfo(productId: productId))
                    } label: {
                        Text("修改")
                            .font(AppTypography.body2)
                            .foregroundColor(AppColors.primary)
                    }
                }

                if let address = viewModel.selectedAddress {
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
                } else {
                    Button {
                        router.push(.deliveryInfo(productId: productId))
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("添加收货地址")
                        }
                        .font(AppTypography.body2)
                        .foregroundColor(AppColors.primary)
                    }
                }
            }
        }
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: "exclamationmark.circle")
                    .font(.system(size: 12))
                Text("温馨提示")
                    .font(AppTypography.caption)
            }
            .foregroundColor(AppColors.textSecondary)

            Text("· 积分兑换成功后不可退换\n· 预计3-5个工作日内发货")
                .font(AppTypography.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(AppSpacing.md)
    }

    private func buttonBar(_ product: Product) -> some View {
        HStack(spacing: AppSpacing.md) {
            ASButton("取消", style: .outline) {
                dismiss()
            }
            .frame(maxWidth: .infinity)

            ASButton(
                "确认兑换",
                isLoading: viewModel.isSubmitting,
                isDisabled: viewModel.selectedAddress == nil || viewModel.currentBalance < product.pointsPrice
            ) {
                Task {
                    if let orderId = await viewModel.submitOrder() {
                        router.popToRoot()
                        router.push(.redemptionSuccess(orderId: orderId))
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(AppSpacing.lg)
        .background(AppColors.bgWhite)
    }
}

@MainActor
final class ConfirmRedemptionViewModel: ObservableObject {
    @Published var product: Product?
    @Published var selectedAddress: Address?
    @Published var currentBalance: Int = 0
    @Published var isLoading = false
    @Published var isSubmitting = false
    @Published var showError = false
    @Published var errorMessage: String?

    private let productId: Int64
    private let productRepository: ProductRepositoryProtocol
    private let pointsRepository: PointsRepositoryProtocol
    private let addressRepository: AddressRepositoryProtocol
    private let orderRepository: OrderRepositoryProtocol

    init(
        productId: Int64,
        productRepository: ProductRepositoryProtocol = ProductRepository(),
        pointsRepository: PointsRepositoryProtocol = PointsRepository(),
        addressRepository: AddressRepositoryProtocol = AddressRepository(),
        orderRepository: OrderRepositoryProtocol = OrderRepository()
    ) {
        self.productId = productId
        self.productRepository = productRepository
        self.pointsRepository = pointsRepository
        self.addressRepository = addressRepository
        self.orderRepository = orderRepository
    }

    func loadData() async {
        isLoading = true

        async let productTask = loadProduct()
        async let balanceTask = loadBalance()
        async let addressTask = loadDefaultAddress()

        await productTask
        await balanceTask
        await addressTask

        isLoading = false
    }

    private func loadProduct() async {
        do {
            product = try await productRepository.getProductDetail(id: productId)
        } catch {
            print("Failed to load product: \(error)")
        }
    }

    private func loadBalance() async {
        do {
            let balance = try await pointsRepository.getBalance()
            currentBalance = balance.balance
        } catch {
            print("Failed to load balance: \(error)")
        }
    }

    private func loadDefaultAddress() async {
        do {
            let addresses = try await addressRepository.getAddresses()
            selectedAddress = addresses.first { $0.isDefault } ?? addresses.first
        } catch {
            print("Failed to load addresses: \(error)")
        }
    }

    func submitOrder() async -> Int64? {
        guard let address = selectedAddress else { return nil }

        isSubmitting = true

        do {
            let order = try await orderRepository.createOrder(productId: productId, addressId: address.id)
            isSubmitting = false
            return order.id
        } catch let error as APIError {
            errorMessage = error.errorDescription
            showError = true
        } catch {
            errorMessage = "兑换失败，请稍后重试"
            showError = true
        }

        isSubmitting = false
        return nil
    }
}

#Preview {
    NavigationStack {
        ConfirmRedemptionView(productId: 1)
            .environmentObject(AppRouter())
    }
}
