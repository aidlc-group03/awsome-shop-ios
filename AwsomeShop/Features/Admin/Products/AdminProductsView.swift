import SwiftUI

struct AdminProductsView: View {
    @StateObject private var viewModel = AdminProductsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView {
                VStack(spacing: AppSpacing.md) {
                    searchBar

                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.top, 50)
                    } else {
                        productList
                    }
                }
                .padding(AppSpacing.lg)
            }
        }
        .background(AppColors.bgPage)
        .task {
            await viewModel.loadProducts()
        }
    }

    private var navigationBar: some View {
        HStack {
            Text("商品管理")
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

            TextField("搜索商品", text: $viewModel.searchText)
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

    private var productList: some View {
        LazyVStack(spacing: AppSpacing.md) {
            ForEach(viewModel.filteredProducts) { product in
                AdminProductRow(product: product) {
                    // Toggle status
                } onEdit: {
                    // Edit product
                }
            }
        }
    }
}

struct AdminProductRow: View {
    let product: Product
    let onToggleStatus: () -> Void
    let onEdit: () -> Void

    var body: some View {
        HStack(spacing: AppSpacing.md) {
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
            .frame(width: 60, height: 60)
            .cornerRadius(CornerRadius.md)

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(AppTypography.body2)
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(1)

                HStack(spacing: AppSpacing.sm) {
                    Text("\(product.pointsPrice) 积分")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.primary)

                    Text("库存: \(product.stock)")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                }

                HStack(spacing: AppSpacing.sm) {
                    ASStatusBadge(
                        title: product.isOnShelf ? "上架" : "下架",
                        type: product.isOnShelf ? .completed : .cancelled
                    )
                    Text(product.category)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
            }

            Spacer()

            VStack(spacing: AppSpacing.sm) {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .foregroundColor(AppColors.primary)
                }

                Button(action: onToggleStatus) {
                    Image(systemName: product.isOnShelf ? "eye.slash" : "eye")
                        .foregroundColor(product.isOnShelf ? AppColors.warning : AppColors.success)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.bgWhite)
        .cornerRadius(CornerRadius.lg)
    }
}

@MainActor
final class AdminProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var searchText = ""
    @Published var isLoading = false

    private let productRepository: ProductRepositoryProtocol

    init(productRepository: ProductRepositoryProtocol = ProductRepository()) {
        self.productRepository = productRepository
    }

    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        }
        return products.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    func loadProducts() async {
        isLoading = true

        do {
            let response = try await productRepository.getProducts(page: 1, size: 50, category: nil)
            products = response.records
        } catch {
            print("Failed to load products: \(error)")
        }

        isLoading = false
    }
}

#Preview {
    AdminProductsView()
}
