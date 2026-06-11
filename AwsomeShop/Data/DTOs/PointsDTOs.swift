import Foundation

struct TransactionQueryRequest: Codable {
    let page: Int
    let size: Int
    let type: String?

    init(page: Int = 1, size: Int = 20, type: TransactionType? = nil) {
        self.page = page
        self.size = size
        self.type = type?.rawValue
    }
}
