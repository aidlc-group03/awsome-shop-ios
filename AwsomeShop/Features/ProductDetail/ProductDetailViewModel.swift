import Foundation

@MainActor
final class ProductDetailViewModel: ObservableObject {
    @Published var product: Product?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let productId: Int64
    private let productRepository: ProductRepositoryProtocol

    init(productId: Int64, productRepository: ProductRepositoryProtocol = ProductRepository()) {
        self.productId = productId
        self.productRepository = productRepository
    }

    func loadProduct() async {
        isLoading = true
        errorMessage = nil

        do {
            product = try await productRepository.getProductDetail(id: productId)
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "加载商品失败"
        }

        isLoading = false
    }
}
