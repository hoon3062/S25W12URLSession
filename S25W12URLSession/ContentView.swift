import SwiftUI

struct ContentView: View {
    @State private var viewModel = SongViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.songs) { song in
                VStack(alignment: .leading) {
                    Text(song.title)
                        .font(.headline)
                    Text(song.singer)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .task {
            await viewModel.loadSongs()
        }
        .refreshable {
            await viewModel.loadSongs()
        }
    }
}

#Preview {
    ContentView()
}
