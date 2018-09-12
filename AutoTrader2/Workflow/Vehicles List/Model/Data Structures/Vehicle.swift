import Foundation

struct Vehicle: Codable {
    let make: String
    let model: String
    let year: Int
    let id: UUID
    let price: Int
}
