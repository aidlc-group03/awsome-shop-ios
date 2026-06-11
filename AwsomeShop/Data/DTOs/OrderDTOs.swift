import Foundation

struct CreateOrderRequest: Codable {
    let productId: Int64
    let addressId: Int64
}

struct OrderListRequest: Codable {
    let page: Int
    let size: Int
    let status: String?

    init(page: Int = 1, size: Int = 10, status: OrderStatus? = nil) {
        self.page = page
        self.size = size
        self.status = status?.rawValue
    }
}

struct OrderDetailRequest: Codable {
    let id: Int64
}
