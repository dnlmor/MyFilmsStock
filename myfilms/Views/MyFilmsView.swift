import SwiftUI

struct MyFilmsView: View {
    @ObservedObject var viewModel = MovieViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.movies) { movie in
                HStack {
                    Text(movie.title ?? "Unknown")
                    Spacer()
                    Button(action: {
                        deleteMovie(movie)
                    }) {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                viewModel.fetchSavedMovies()
            }
            .navigationTitle("My Films")
        }
    }

    private func deleteMovie(_ movie: Film) {
        PersistenceController.shared.deleteFilm(film: movie)
        viewModel.fetchSavedMovies()
    }
}
