import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .home
    @EnvironmentObject var router: AppRouter

    var body: some View {
        VStack(spacing: 0) {
            tabContent
            ASBottomTabBar(selectedTab: $selectedTab)
        }
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .home:
            HomeView()
        case .points:
            PointsCenterView()
        case .orders:
            OrdersView()
        case .profile:
            ProfileView()
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppRouter())
        .environmentObject(AuthManager.shared)
}
