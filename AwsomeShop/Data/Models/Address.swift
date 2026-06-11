import Foundation

struct Address: Codable, Identifiable {
    let id: Int64
    let userId: Int64
    let name: String
    let phone: String
    let region: String
    let detail: String
    let isDefault: Bool

    var fullAddress: String {
        "\(region) \(detail)"
    }
}
