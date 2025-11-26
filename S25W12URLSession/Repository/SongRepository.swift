protocol SongRepository: Sendable {
    func fetchSongs() async throws -> [Song]
    
    func saveSong(_ song: Song) async throws
    
    func deleteSong(_ id: String) async throws
}
