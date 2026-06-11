import SwiftUI

struct PointsCenterView: View {
    @StateObject private var viewModel = PointsCenterViewModel()
    @EnvironmentObject var router: AppRouter

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView {
                VStack(spacing: AppSpacing.xxl) {
                    balanceCard
                    quickActions
                    recentTransactions
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
            Text("积分中心")
                .font(AppTypography.headline3)
                .foregroundColor(AppColors.textPrimary)
            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .background(AppColors.bgWhite)
    }

    private var balanceCard: some View {
        VStack(spacing: AppSpacing.lg) {
            Text("当前积分")
                .font(AppTypography.body2)
                .foregroundColor(AppColors.textWhite.opacity(0.8))

            Text("\(viewModel.balance?.balance ?? 0)")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(AppColors.textWhite)

            HStack(spacing: AppSpacing.xxxl) {
                VStack(spacing: 4) {
                    Text("累计获得")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textWhite.opacity(0.7))
                    Text("\(viewModel.balance?.totalEarned ?? 0)")
                        .font(AppTypography.headline3)
                        .foregroundColor(AppColors.textWhite)
                }

                VStack(spacing: 4) {
                    Text("累计使用")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textWhite.opacity(0.7))
                    Text("\(viewModel.balance?.totalUsed ?? 0)")
                        .font(AppTypography.headline3)
                        .foregroundColor(AppColors.textWhite)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.xxxl)
        .background(
            LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(CornerRadius.lg)
    }

    private var quickActions: some View {
        HStack(spacing: AppSpacing.md) {
            quickActionItem(icon: "list.bullet.rectangle", title: "兑换记录") {
                router.push(.pointsHistory)
            }

            quickActionItem(icon: "doc.text", title: "积分明细") {
                router.push(.pointsHistory)
            }

            quickActionItem(icon: "questionmark.circle", title: "积分规则") {}
        }
    }

    private func quickActionItem(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.primary)
                Text(title)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.lg)
            .background(AppColors.bgWhite)
            .cornerRadius(CornerRadius.md)
        }
    }

    private var recentTransactions: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("最近交易")
                    .font(AppTypography.headline3)
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
                Button {
                    router.push(.pointsHistory)
                } label: {
                    HStack(spacing: 4) {
                        Text("查看全部")
                            .font(AppTypography.caption)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(AppColors.primary)
                }
            }

            VStack(spacing: 0) {
                ForEach(viewModel.recentTransactions) { transaction in
                    TransactionRow(transaction: transaction)
                    if transaction.id != viewModel.recentTransactions.last?.id {
                        Divider()
                            .padding(.leading, 44)
                    }
                }
            }
            .background(AppColors.bgWhite)
            .cornerRadius(CornerRadius.lg)
        }
    }
}

struct TransactionRow: View {
    let transaction: PointsTransaction

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter
    }()

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: transaction.type.icon)
                .font(.system(size: 18))
                .foregroundColor(transaction.type.isEarning ? AppColors.success : AppColors.error)
                .frame(width: 36, height: 36)
                .background(
                    (transaction.type.isEarning ? AppColors.chipGreenBg : AppColors.chipRedBg)
                )
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.description)
                    .font(AppTypography.body2)
                    .foregroundColor(AppColors.textPrimary)
                Text(dateFormatter.string(from: transaction.createdAt))
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
            }

            Spacer()

            Text(transaction.type.isEarning ? "+\(transaction.amount)" : "\(transaction.amount)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(transaction.type.isEarning ? AppColors.success : AppColors.error)
        }
        .padding(AppSpacing.md)
    }
}

@MainActor
final class PointsCenterViewModel: ObservableObject {
    @Published var balance: PointsBalance?
    @Published var recentTransactions: [PointsTransaction] = []
    @Published var isLoading = false

    private let pointsRepository: PointsRepositoryProtocol

    init(pointsRepository: PointsRepositoryProtocol = PointsRepository()) {
        self.pointsRepository = pointsRepository
    }

    func loadData() async {
        isLoading = true

        async let balanceTask = loadBalance()
        async let transactionsTask = loadTransactions()

        await balanceTask
        await transactionsTask

        isLoading = false
    }

    private func loadBalance() async {
        do {
            balance = try await pointsRepository.getBalance()
        } catch {
            print("Failed to load balance: \(error)")
        }
    }

    private func loadTransactions() async {
        do {
            let response = try await pointsRepository.getTransactions(page: 1, size: 5, type: nil)
            recentTransactions = response.records
        } catch {
            print("Failed to load transactions: \(error)")
        }
    }
}

#Preview {
    PointsCenterView()
        .environmentObject(AppRouter())
}
