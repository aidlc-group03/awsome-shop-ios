import SwiftUI

struct PointsHistoryView: View {
    @StateObject private var viewModel = PointsHistoryViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            filterTabs
            transactionList
        }
        .background(AppColors.bgPage)
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.loadTransactions()
        }
    }

    private var navigationBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(AppColors.textPrimary)
            }

            Spacer()

            Text("积分明细")
                .font(AppTypography.headline3)
                .foregroundColor(AppColors.textPrimary)

            Spacer()

            Color.clear.frame(width: 24)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .background(AppColors.bgWhite)
    }

    private var filterTabs: some View {
        HStack(spacing: AppSpacing.sm) {
            FilterTab(title: "全部", isSelected: viewModel.filterType == nil) {
                Task { await viewModel.setFilter(nil) }
            }
            FilterTab(title: "获取", isSelected: viewModel.filterType == .earning) {
                Task { await viewModel.setFilter(.earning) }
            }
            FilterTab(title: "使用", isSelected: viewModel.filterType == .spending) {
                Task { await viewModel.setFilter(.spending) }
            }
        }
        .padding(AppSpacing.lg)
        .background(AppColors.bgWhite)
    }

    private var transactionList: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 100)
            } else if viewModel.transactions.isEmpty {
                emptyState
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.transactions) { transaction in
                        TransactionRow(transaction: transaction)
                        Divider()
                            .padding(.leading, 60)
                    }
                }
                .background(AppColors.bgWhite)
                .cornerRadius(CornerRadius.lg)
                .padding(AppSpacing.lg)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "doc.text")
                .font(.system(size: 60))
                .foregroundColor(AppColors.textDisabled)

            Text("暂无交易记录")
                .font(AppTypography.body1)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.top, 100)
    }
}

struct FilterTab: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.body2)
                .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.sm)
                .background(isSelected ? AppColors.primaryBg : Color.clear)
                .cornerRadius(CornerRadius.md)
        }
    }
}

enum FilterType {
    case earning
    case spending
}

@MainActor
final class PointsHistoryViewModel: ObservableObject {
    @Published var transactions: [PointsTransaction] = []
    @Published var filterType: FilterType? = nil
    @Published var isLoading = false

    private let pointsRepository: PointsRepositoryProtocol

    init(pointsRepository: PointsRepositoryProtocol = PointsRepository()) {
        self.pointsRepository = pointsRepository
    }

    func loadTransactions() async {
        isLoading = true

        do {
            let response = try await pointsRepository.getTransactions(page: 1, size: 50, type: nil)
            var records = response.records

            if let filter = filterType {
                records = records.filter { transaction in
                    switch filter {
                    case .earning: return transaction.type.isEarning
                    case .spending: return !transaction.type.isEarning
                    }
                }
            }

            transactions = records
        } catch {
            print("Failed to load transactions: \(error)")
        }

        isLoading = false
    }

    func setFilter(_ type: FilterType?) async {
        filterType = type
        await loadTransactions()
    }
}

#Preview {
    NavigationStack {
        PointsHistoryView()
    }
}
