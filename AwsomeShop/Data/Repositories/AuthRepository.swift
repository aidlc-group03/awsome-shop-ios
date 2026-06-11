import Foundation

protocol AuthRepositoryProtocol {
    func login(username: String, password: String) async throws -> LoginResponse
    func getProfile() async throws -> User
}

final class AuthRepository: AuthRepositoryProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func login(username: String, password: String) async throws -> LoginResponse {
        let request = LoginRequest(username: username, password: password)
        return try await apiClient.request(.login, body: request)
    }

    func getProfile() async throws -> User {
        return try await apiClient.request(.profile)
    }
}
