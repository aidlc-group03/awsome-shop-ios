import Foundation

protocol PointsRepositoryProtocol {
    func getBalance() async throws -> PointsBalance
    func getTransactions(page: Int, size: Int, type: TransactionType?) async throws -> PageResponse<PointsTransaction>
}

final class PointsRepository: PointsRepositoryProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func getBalance() async throws -> PointsBalance {
        return try await apiClient.request(.pointsBalance)
    }

    func getTransactions(page: Int, size: Int, type: TransactionType?) async throws -> PageResponse<PointsTransaction> {
        let request = TransactionQueryRequest(page: page, size: size, type: type)
        return try await apiClient.request(.pointsTransactions, body: request)
    }
}
