import Foundation

protocol ProductRepositoryProtocol {
    func getProducts(page: Int, size: Int, category: String?) async throws -> PageResponse<Product>
    func getProductDetail(id: Int64) async throws -> Product
    func getCategories() async throws -> [Category]
}

final class ProductRepository: ProductRepositoryProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func getProducts(page: Int, size: Int, category: String?) async throws -> PageResponse<Product> {
        let request = ListProductRequest(page: page, size: size, category: category)
        return try await apiClient.request(.productList, body: request)
    }

    func getProductDetail(id: Int64) async throws -> Product {
        let request = ProductDetailRequest(id: id)
        return try await apiClient.request(.productDetail, body: request)
    }

    func getCategories() async throws -> [Category] {
        return try await apiClient.request(.categories)
    }
}
