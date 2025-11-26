import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SongView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Songs")
                }
            SingerView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Singer")
                }
        }
    }
}

struct SongView: View {
    @State private var viewModel = SongViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            SongListView(viewModel: viewModel)
            .navigationDestination(for: Song.self) { song in
                SongDetailView(song: song)
            }
            .navigationTitle("노래")
            .task {
                await viewModel.loadSongs()
            }
            .refreshable {
                await viewModel.loadSongs()
            }
        }
    }
}

struct SongListView: View {
    let viewModel: SongViewModel
    
    var body: some View {
        List(viewModel.songs) { song in
            NavigationLink(value: song) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(song.title)
                            .font(.headline)
                        Text(song.singer)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .task {
            await viewModel.addSong(
                Song(id: UUID(), title: "test", singer: "singer", rating: 1, lyrics: "lyrics")
            )
        }
    }
}

struct SongDetailView: View {
    let song: Song

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text(song.singer)
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(String(song.rating))
                        .font(.title)
                        .foregroundColor(.yellow)
                }
                .padding(.bottom, 10)

                Text(song.lyrics ?? "(가사 없음)")
                    .font(.body)
                    .multilineTextAlignment(.leading)
            }
            .padding()
        }
        .navigationTitle(song.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SingerView: View {
    var body: some View {
        Text("Singer View")
    }
}

#Preview {
    ContentView()
}
