import Foundation

struct Product: Codable, Identifiable {
    let id: Int64
    let name: String
    let sku: String
    let category: String
    let brand: String?
    let pointsPrice: Int
    let marketPrice: Double?
    let stock: Int
    let soldCount: Int?
    let status: Int
    let description: String?
    let imageUrl: String?
    let subtitle: String?
    let deliveryMethod: String?
    let serviceGuarantee: String?
    let promotion: String?
    let colors: String?
    let specs: [[String: String]]?
    let createdAt: Date?
    let updatedAt: Date?

    var isInStock: Bool {
        stock > 0
    }

    var isOnShelf: Bool {
        status == 1
    }
}

struct Category: Codable, Identifiable {
    let id: Int64
    let name: String
    let description: String?
    let icon: String?
    let sortOrder: Int?
    let status: Int?
}
