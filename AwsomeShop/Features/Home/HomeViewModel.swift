import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var categories: [Category] = []
    @Published var selectedCategory: String? = nil
    @Published var pointsBalance: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let productRepository: ProductRepositoryProtocol
    private let pointsRepository: PointsRepositoryProtocol

    init(
        productRepository: ProductRepositoryProtocol = ProductRepository(),
        pointsRepository: PointsRepositoryProtocol = PointsRepository()
    ) {
        self.productRepository = productRepository
        self.pointsRepository = pointsRepository
    }

    func loadInitialData() async {
        isLoading = true
        errorMessage = nil

        async let categoriesTask = loadCategories()
        async let productsTask = loadProducts()
        async let balanceTask = loadBalance()

        await categoriesTask
        await productsTask
        await balanceTask

        isLoading = false
    }

    func loadCategories() async {
        do {
            categories = try await productRepository.getCategories()
        } catch {
            print("Failed to load categories: \(error)")
        }
    }

    func loadProducts() async {
        do {
            let response = try await productRepository.getProducts(
                page: 1,
                size: 20,
                category: selectedCategory
            )
            products = response.records
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "加载商品失败"
        }
    }

    func loadBalance() async {
        do {
            let balance = try await pointsRepository.getBalance()
            pointsBalance = balance.balance
        } catch {
            print("Failed to load balance: \(error)")
        }
    }

    func selectCategory(_ category: String?) async {
        selectedCategory = category
        await loadProducts()
    }
}
