import Foundation

@MainActor
final class OrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var selectedStatus: OrderStatus? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let orderRepository: OrderRepositoryProtocol

    init(orderRepository: OrderRepositoryProtocol = OrderRepository()) {
        self.orderRepository = orderRepository
    }

    func loadOrders() async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await orderRepository.getOrders(
                page: 1,
                size: 20,
                status: selectedStatus
            )
            orders = response.records
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "加载订单失败"
        }

        isLoading = false
    }

    func selectStatus(_ status: OrderStatus?) async {
        selectedStatus = status
        await loadOrders()
    }
}
