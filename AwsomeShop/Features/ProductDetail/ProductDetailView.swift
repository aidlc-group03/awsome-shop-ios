import SwiftUI

struct ProductDetailView: View {
    let productId: Int64
    @StateObject private var viewModel: ProductDetailViewModel
    @EnvironmentObject var router: AppRouter
    @Environment(\.dismiss) var dismiss

    init(productId: Int64) {
        self.productId = productId
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(productId: productId))
    }

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let product = viewModel.product {
                productContent(product)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(AppColors.error)
            }
        }
        .background(AppColors.bgPage)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppColors.textPrimary)
                }
            }
        }
        .task {
            await viewModel.loadProduct()
        }
    }

    private func productContent(_ product: Product) -> some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xxl) {
                    productImage(product)

                    VStack(alignment: .leading, spacing: AppSpacing.lg) {
                        breadcrumb(product)
                        productTitle(product)
                        priceCard(product)
                        infoSection(product)
                        descriptionSection(product)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                }
            }

            bottomBar(product)
        }
    }

    private func productImage(_ product: Product) -> some View {
        ZStack {
            AppColors.primaryBg

            if let imageUrl = product.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    default:
                        Image(systemName: "bag.fill")
                            .font(.system(size: 80))
                            .foregroundColor(AppColors.primary.opacity(0.3))
                    }
                }
            } else {
                Image(systemName: "bag.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.primary.opacity(0.3))
            }
        }
        .frame(height: 300)
    }

    private func breadcrumb(_ product: Product) -> some View {
        HStack(spacing: 6) {
            Text("首页")
            Image(systemName: "chevron.right")
                .font(.system(size: 10))
            Text(product.category)
            Image(systemName: "chevron.right")
                .font(.system(size: 10))
            Text(product.name)
                .lineLimit(1)
        }
        .font(AppTypography.caption)
        .foregroundColor(AppColors.textSecondary)
    }

    private func productTitle(_ product: Product) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(product.name)
                .font(AppTypography.headline2)
                .foregroundColor(AppColors.textPrimary)

            if let subtitle = product.subtitle {
                Text(subtitle)
                    .font(AppTypography.body2)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
    }

    private func priceCard(_ product: Product) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("限时兑换")
                .font(AppTypography.caption)
                .foregroundColor(AppColors.chipOrangeText)

            HStack(alignment: .bottom, spacing: AppSpacing.sm) {
                Text("\(product.pointsPrice)")
                    .font(AppTypography.headline1)
                    .foregroundColor(AppColors.accent)
                Text("积分")
                    .font(AppTypography.body1)
                    .foregroundColor(AppColors.accent)

                Spacer()

                if let marketPrice = product.marketPrice {
                    Text("市场价 ¥\(Int(marketPrice))")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .strikethrough()
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(
            LinearGradient(
                colors: [AppColors.accentBg, AppColors.accentLight.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(CornerRadius.md)
    }

    private func infoSection(_ product: Product) -> some View {
        VStack(spacing: AppSpacing.md) {
            if let delivery = product.deliveryMethod {
                infoRow(icon: "shippingbox", title: "配送方式", value: delivery)
            }
            if let service = product.serviceGuarantee {
                infoRow(icon: "checkmark.shield", title: "服务保障", value: service)
            }
            if product.stock > 0 {
                infoRow(icon: "cube.box", title: "库存", value: "有货")
            } else {
                infoRow(icon: "cube.box", title: "库存", value: "缺货")
            }
        }
    }

    private func infoRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppColors.textSecondary)
                .frame(width: 20)
            Text(title)
                .font(AppTypography.body2)
                .foregroundColor(AppColors.textSecondary)
            Spacer()
            Text(value)
                .font(AppTypography.body2)
                .foregroundColor(AppColors.textPrimary)
        }
    }

    private func descriptionSection(_ product: Product) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("商品描述")
                .font(AppTypography.headline3)
                .foregroundColor(AppColors.textPrimary)

            Text(product.description ?? "暂无描述")
                .font(AppTypography.body2)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.top, AppSpacing.lg)
    }

    private func bottomBar(_ product: Product) -> some View {
        HStack(spacing: AppSpacing.md) {
            Button {} label: {
                Image(systemName: "heart")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.textSecondary)
                    .frame(width: 48, height: 48)
                    .background(AppColors.bgWhite)
                    .cornerRadius(CornerRadius.md)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.md)
                            .stroke(AppColors.border, lineWidth: 1)
                    )
            }

            ASButton(
                "立即兑换 · \(product.pointsPrice)积分",
                isDisabled: product.stock <= 0
            ) {
                router.push(.confirmRedemption(productId: product.id))
            }
        }
        .padding(AppSpacing.lg)
        .background(AppColors.bgWhite)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(AppColors.borderLight),
            alignment: .top
        )
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(productId: 1)
            .environmentObject(AppRouter())
    }
}
