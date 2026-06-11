import Foundation

struct ListProductRequest: Codable {
    let page: Int
    let size: Int
    let name: String?
    let category: String?

    init(page: Int = 1, size: Int = 10, name: String? = nil, category: String? = nil) {
        self.page = page
        self.size = size
        self.name = name
        self.category = category
    }
}

struct ProductDetailRequest: Codable {
    let id: Int64
}
