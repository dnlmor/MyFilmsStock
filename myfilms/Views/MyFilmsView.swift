import SwiftUI

struct MyFilmsView: View {
    @ObservedObject var viewModel: MovieViewModel

    var body: some View {
        VStack {
            List(viewModel.movies) { movie in
                MovieRowView(film: movie)
            }
            .onAppear {
                viewModel.fetchSavedMovies()
            }
        }
        .navigationTitle("My Films")
    }
}
