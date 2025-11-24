import Foundation

final class SupabaseSongRepository: SongRepository {
    func fetchSongs() async throws -> [Song] {
        let requestURL = URL(string: SongApiConfig.serverURL)!
        let (data, _) = try! await URLSession.shared.data(from: requestURL)
        let decoder = JSONDecoder()
        return try! decoder.decode([Song].self, from: data)
    }
}
