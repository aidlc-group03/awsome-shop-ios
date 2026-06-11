import SwiftUI

enum AdminTabItem: Int, CaseIterable {
    case dashboard = 0
    case products = 1
    case orders = 2
    case users = 3

    var title: String {
        switch self {
        case .dashboard: return "概览"
        case .products: return "商品"
        case .orders: return "订单"
        case .users: return "用户"
        }
    }

    var icon: String {
        switch self {
        case .dashboard: return "chart.bar.fill"
        case .products: return "bag.fill"
        case .orders: return "list.clipboard.fill"
        case .users: return "person.2.fill"
        }
    }
}

struct AdminTabView: View {
    @State private var selectedTab: AdminTabItem = .dashboard
    @EnvironmentObject var router: AppRouter

    var body: some View {
        VStack(spacing: 0) {
            tabContent
            AdminBottomTabBar(selectedTab: $selectedTab)
        }
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .dashboard:
            AdminDashboardView()
        case .products:
            AdminProductsView()
        case .orders:
            AdminOrdersView()
        case .users:
            AdminUsersView()
        }
    }
}

struct AdminBottomTabBar: View {
    @Binding var selectedTab: AdminTabItem

    var body: some View {
        HStack {
            ForEach(AdminTabItem.allCases, id: \.rawValue) { tab in
                Spacer()
                AdminTabBarItem(tab: tab, isSelected: selectedTab == tab) {
                    selectedTab = tab
                }
                Spacer()
            }
        }
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, 34)
        .background(AppColors.bgWhite)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(AppColors.borderLight),
            alignment: .top
        )
    }
}

private struct AdminTabBarItem: View {
    let tab: AdminTabItem
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 22))
                Text(tab.title)
                    .font(.system(size: 10))
            }
            .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
        }
    }
}

#Preview {
    AdminTabView()
        .environmentObject(AppRouter())
}
