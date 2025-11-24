import Foundation

struct Song: Identifiable, Decodable {
    let id: UUID
    let title: String
    let singer: String
    let rating: Int
    let lyrics: String?
}
