import Foundation

struct APIResponse<T: Codable>: Codable {
    let code: String
    let message: String
    let data: T?

    var isSuccess: Bool {
        code == "SUCCESS"
    }
}

struct PageResponse<T: Codable>: Codable {
    let current: Int
    let size: Int
    let total: Int
    let pages: Int
    let records: [T]
}

struct EmptyResponse: Codable {}
