import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIEndpoint {
    case login
    case profile

    case productList
    case productDetail
    case categories

    case pointsBalance
    case pointsTransactions

    case createOrder
    case orderList
    case orderDetail

    case addressList
    case createAddress
    case updateAddress
    case deleteAddress
    case setDefaultAddress

    var path: String {
        switch self {
        case .login: return "/public/auth/login"
        case .profile: return "/auth/profile"

        case .productList: return "/public/product/list"
        case .productDetail: return "/public/product/detail"
        case .categories: return "/public/product/categories"

        case .pointsBalance: return "/point/balance"
        case .pointsTransactions: return "/point/transactions"

        case .createOrder: return "/order/create"
        case .orderList: return "/order/list"
        case .orderDetail: return "/order/detail"

        case .addressList: return "/address/list"
        case .createAddress: return "/address/create"
        case .updateAddress: return "/address/update"
        case .deleteAddress: return "/address/delete"
        case .setDefaultAddress: return "/address/set-default"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .profile:
            return .get
        default:
            return .post
        }
    }

    var requiresAuth: Bool {
        switch self {
        case .login, .productList, .productDetail, .categories:
            return false
        default:
            return true
        }
    }
}
