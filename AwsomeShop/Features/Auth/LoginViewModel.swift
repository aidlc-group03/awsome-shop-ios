import Foundation
import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }

    var isValid: Bool {
        !username.isEmpty && !password.isEmpty
    }

    func login() async {
        guard isValid else {
            errorMessage = "请输入用户名和密码"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await authRepository.login(username: username, password: password)
            await AuthManager.shared.login(token: response.token, user: response.user)
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "登录失败，请稍后重试"
        }

        isLoading = false
    }
}
