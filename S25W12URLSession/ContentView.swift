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
    @State private var showingAddSheet = false
    
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
                .toolbar {
                    Button {
                        showingAddSheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                .sheet(isPresented: $showingAddSheet) {
                    SongAddView(viewModel: viewModel)
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
//        .task {
//            await viewModel.addSong(
//                Song(id: UUID(), title: "test", singer: "singer", rating: 1, lyrics: "lyrics")
//            )
//        }
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

struct SongAddView: View {
    let viewModel: SongViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var title = ""
    @State var singer = ""
    @State var rating = 3
    @State var lyrics = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("노래 정보 *")) {
                    TextField("제목", text: $title)
                    TextField("가수", text: $singer)
                }
                
                Section(header: Text("선호도 *")) {
                    Picker("별점", selection: $rating) {
                        ForEach(1...5, id: \.self) { score in
                            Text("\(score)점")
                                .tag(score)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("가사")) {
                    TextEditor(text: $lyrics)
                        .frame(height: 150)
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("추가") {
                        Task {
                            await viewModel.addSong(
                                Song(id: UUID(), title: title, singer: singer, rating: rating, lyrics: lyrics)
                            )
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty || singer.isEmpty)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
