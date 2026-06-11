import SwiftUI

struct ContentView: View {
    @StateObject private var router = AppRouter()
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        Group {
            if authManager.isLoggedIn {
                NavigationStack(path: $router.path) {
                    MainTabView()
                        .navigationDestination(for: Route.self) { route in
                            destinationView(for: route)
                        }
                }
                .environmentObject(router)
            } else {
                LoginView()
            }
        }
    }

    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .login:
            LoginView()
        case .main:
            MainTabView()
        case .productDetail(let productId):
            ProductDetailView(productId: productId)
        case .confirmRedemption(let productId):
            ConfirmRedemptionView(productId: productId)
        case .deliveryInfo(let productId):
            DeliveryInfoView(productId: productId)
        case .redemptionSuccess(let orderId):
            RedemptionSuccessView(orderId: orderId)
        case .orderDetail(let orderId):
            OrderDetailView(orderId: orderId)
        case .pointsHistory:
            PointsHistoryView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager.shared)
}
