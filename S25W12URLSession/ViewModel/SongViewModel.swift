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

    var path = NavigationPath()

    func loadSongs() async {
        _songs = try! await repository.fetchSongs()
    }
    
    // func addSong(newSong song: Song)
    // newSong은 외부 매개변수 이름, song은 함수 내부에서 사용하는 매개변수 이름
    // viewModel.addSong(newSong: song)
    //
    // _는 외부 매개변수 이름을 사용하지 않겠다는 표현
    // viewModel.addSong(song)
    func addSong(_ song: Song) async {
        do {
            try await repository.saveSong(song)
            _songs.append(song)
        }
        catch {
            debugPrint("에러 발생: \(error)")
        }
    }
}
