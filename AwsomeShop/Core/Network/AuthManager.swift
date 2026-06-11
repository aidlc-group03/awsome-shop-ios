import Foundation
import SwiftUI

@MainActor
final class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published private(set) var isLoggedIn: Bool = false
    @Published private(set) var currentUser: User?

    private let tokenKey = "auth_token"
    private let userKey = "current_user"

    var token: String? {
        UserDefaults.standard.string(forKey: tokenKey)
    }

    private init() {
        loadStoredAuth()
    }

    private func loadStoredAuth() {
        if let token = UserDefaults.standard.string(forKey: tokenKey), !token.isEmpty {
            isLoggedIn = true
            if let userData = UserDefaults.standard.data(forKey: userKey),
               let user = try? JSONDecoder().decode(User.self, from: userData) {
                currentUser = user
            }
        }
    }

    func login(token: String, user: User) {
        UserDefaults.standard.set(token, forKey: tokenKey)
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: userKey)
        }
        isLoggedIn = true
        currentUser = user
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: userKey)
        isLoggedIn = false
        currentUser = nil
    }
}
