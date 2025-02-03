import SwiftUI

struct MovieListView: View {
    @FetchRequest(
        entity: Film.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Film.title, ascending: true)],
        predicate: nil,
        animation: .default
    ) private var films: FetchedResults<Film>

    @State private var searchText = ""
    @State private var sortByTitle = true

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search", text: $searchText)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    Button(action: toggleSort) {
                        Image(systemName: sortByTitle ? "arrow.up.arrow.down.circle.fill" : "arrow.up.arrow.down")
                            .font(.title)
                    }
                    .padding(.leading)
                }
                .padding()

                List {
                    ForEach(films.filter { $0.title?.contains(searchText) ?? true }) { film in
                        NavigationLink(destination: MovieDetailView(film: film)) {
                            HStack {
                                AsyncImage(url: URL(string: film.posterURL ?? "")) { image in
                                    image.resizable()
                                         .scaledToFit()
                                         .frame(width: 50, height: 75)
                                } placeholder: {
                                    Color.gray.frame(width: 50, height: 75)
                                }

                                VStack(alignment: .leading) {
                                    Text(film.title ?? "Unknown")
                                        .font(.headline)
                                    Text("\(film.year)")
                                        .font(.subheadline)
                                    Text("⭐ \(film.rating ?? "0")")
                                        .font(.subheadline)
                                }
                                .padding(.leading)
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationTitle("Movie Library")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AddMovieView()) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                        }
                    }
                }
            }
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let film = films[index]
            PersistenceController.shared.delete(film)
        }
    }

    private func toggleSort() {
        sortByTitle.toggle()
        if sortByTitle {
            films.sort { $0.title ?? "" < $1.title ?? "" }
        } else {
            films.sort { $0.rating ?? "0" > $1.rating ?? "0" }
        }
    }
}
