import SwiftUI

enum TabItem: Int, CaseIterable {
    case home = 0
    case points = 1
    case orders = 2
    case profile = 3

    var title: String {
        switch self {
        case .home: return "首页"
        case .points: return "积分"
        case .orders: return "订单"
        case .profile: return "我的"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .points: return "star.fill"
        case .orders: return "list.bullet.rectangle.fill"
        case .profile: return "person.fill"
        }
    }
}

struct ASBottomTabBar: View {
    @Binding var selectedTab: TabItem

    var body: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                Spacer()
                TabBarItem(tab: tab, isSelected: selectedTab == tab) {
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

private struct TabBarItem: View {
    let tab: TabItem
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
    VStack {
        Spacer()
        ASBottomTabBar(selectedTab: .constant(.home))
    }
}
