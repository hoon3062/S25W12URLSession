protocol SongRepository: Sendable {
    func fetchSongs() async throws -> [Song]
}
