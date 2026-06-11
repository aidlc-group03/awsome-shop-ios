import Foundation

struct CreateAddressRequest: Codable {
    let name: String
    let phone: String
    let region: String
    let detail: String
    let isDefault: Bool
}

struct UpdateAddressRequest: Codable {
    let id: Int64
    let name: String
    let phone: String
    let region: String
    let detail: String
    let isDefault: Bool
}

struct DeleteAddressRequest: Codable {
    let id: Int64
}

struct SetDefaultAddressRequest: Codable {
    let id: Int64
}
