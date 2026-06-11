import Foundation

enum Route: Hashable {
    case login
    case main
    case productDetail(productId: Int64)
    case confirmRedemption(productId: Int64)
    case deliveryInfo(productId: Int64)
    case redemptionSuccess(orderId: Int64)
    case orderDetail(orderId: Int64)
    case pointsHistory
}
