import SwiftUI

@MainActor
@Observable
final class SongViewModel {
    private let repository: SongRepository
        
    init(repository: SongRepository = SupabaseSongRepository()) {
        self.repository = repository
    }

    private var _songs: [Song] = []
    var songs: [Song] { _songs }

    func loadSongs() async {
        _songs = try! await repository.fetchSongs()
    }
}
