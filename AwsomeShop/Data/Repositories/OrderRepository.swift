import Foundation

protocol OrderRepositoryProtocol {
    func createOrder(productId: Int64, addressId: Int64) async throws -> Order
    func getOrders(page: Int, size: Int, status: OrderStatus?) async throws -> PageResponse<Order>
    func getOrderDetail(id: Int64) async throws -> Order
}

final class OrderRepository: OrderRepositoryProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func createOrder(productId: Int64, addressId: Int64) async throws -> Order {
        let request = CreateOrderRequest(productId: productId, addressId: addressId)
        return try await apiClient.request(.createOrder, body: request)
    }

    func getOrders(page: Int, size: Int, status: OrderStatus?) async throws -> PageResponse<Order> {
        let request = OrderListRequest(page: page, size: size, status: status)
        return try await apiClient.request(.orderList, body: request)
    }

    func getOrderDetail(id: Int64) async throws -> Order {
        let request = OrderDetailRequest(id: id)
        return try await apiClient.request(.orderDetail, body: request)
    }
}
