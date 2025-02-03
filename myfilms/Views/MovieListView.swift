import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieViewModel()
    @State private var isShowingMyFilms = false

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.movies) { film in
                    NavigationLink(destination: MovieDetailView(film: film)) {
                        MovieRowView(film: film)
                    }
                }
                .onAppear {
                    viewModel.fetchMovies()
                }
                .navigationTitle("Movies")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isShowingMyFilms.toggle()
                        }) {
                            Text("My Films")
                        }
                    }
                }
            }
            .background(
                NavigationLink(destination: MyFilmsView(viewModel: viewModel), isActive: $isShowingMyFilms) {
                    EmptyView()
                }
            )
        }
    }
}

struct MovieRowView: View {
    var film: Film

    var body: some View {
        HStack {
            if let posterURL = film.posterURL, !posterURL.isEmpty {
                AsyncImage(url: URL(string: posterURL)) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 75)
                } placeholder: {
                    Color.gray.frame(width: 50, height: 75)
                }
            }
            VStack(alignment: .leading) {
                Text(film.title ?? "Unknown Title")
                    .font(.headline)
                Text(film.year > 0 ? "\(film.year)" : "Unknown Year")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
