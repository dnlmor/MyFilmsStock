import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var film: Film

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: film.posterURL ?? "")) { image in
                image.resizable()
                     .scaledToFit()
                     .frame(height: 300)
            } placeholder: {
                Color.gray.frame(height: 300)
            }

            Text(film.title ?? "Unknown")
                .font(.title)
                .fontWeight(.bold)

            Text("\(film.year)")
                .font(.subheadline)
                .padding(.top, 2)

            Text(film.filmDescription ?? "No description available.")
                .padding()
                .multilineTextAlignment(.center)

            HStack {
                Text("⭐ \(film.rating ?? "0")")
                    .font(.title2)
                Spacer()
                Button(action: deleteMovie) {
                    Text("Delete Movie")
                        .foregroundColor(.red)
                        .bold()
                }
            }
            .padding()
        }
        .padding()
    }

    private func deleteMovie() {
        PersistenceController.shared.delete(film)
    }
}
