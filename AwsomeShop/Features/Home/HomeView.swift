import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var router: AppRouter

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView {
                VStack(spacing: AppSpacing.xxl) {
                    PointsBanner(balance: viewModel.pointsBalance) {
                        router.push(.pointsHistory)
                    }
                    .padding(.horizontal, AppSpacing.lg)

                    CategoryFilter(
                        categories: viewModel.categories,
                        selectedCategory: $viewModel.selectedCategory
                    ) { category in
                        Task {
                            await viewModel.selectCategory(category)
                        }
                    }

                    productGrid
                        .padding(.horizontal, AppSpacing.lg)
                }
                .padding(.vertical, AppSpacing.xxl)
            }
        }
        .background(AppColors.bgPage)
        .task {
            await viewModel.loadInitialData()
        }
    }

    private var navigationBar: some View {
        HStack {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "gift.fill")
                    .foregroundColor(AppColors.textWhite)
                Text("AWSome Shop")
                    .font(AppTypography.headline3)
                    .foregroundColor(AppColors.textWhite)
            }

            Spacer()

            HStack(spacing: AppSpacing.lg) {
                Button {} label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppColors.textWhite)
                }

                Button {} label: {
                    Image(systemName: "bell.fill")
                        .foregroundColor(AppColors.textWhite)
                }
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .background(AppColors.primary)
    }

    private var productGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(viewModel.products) { product in
                ProductCard(product: product) {
                    router.push(.productDetail(productId: product.id))
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppRouter())
}
