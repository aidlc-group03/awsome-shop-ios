import Foundation

protocol AddressRepositoryProtocol {
    func getAddresses() async throws -> [Address]
    func createAddress(_ request: CreateAddressRequest) async throws -> Address
    func updateAddress(_ request: UpdateAddressRequest) async throws -> Address
    func deleteAddress(id: Int64) async throws
    func setDefaultAddress(id: Int64) async throws
}

final class AddressRepository: AddressRepositoryProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func getAddresses() async throws -> [Address] {
        return try await apiClient.request(.addressList)
    }

    func createAddress(_ request: CreateAddressRequest) async throws -> Address {
        return try await apiClient.request(.createAddress, body: request)
    }

    func updateAddress(_ request: UpdateAddressRequest) async throws -> Address {
        return try await apiClient.request(.updateAddress, body: request)
    }

    func deleteAddress(id: Int64) async throws {
        try await apiClient.requestWithoutResponse(.deleteAddress, body: DeleteAddressRequest(id: id))
    }

    func setDefaultAddress(id: Int64) async throws {
        try await apiClient.requestWithoutResponse(.setDefaultAddress, body: SetDefaultAddressRequest(id: id))
    }
}
