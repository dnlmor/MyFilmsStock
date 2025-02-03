import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var film: Film
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: film.posterURL ?? "")) { image in
                    image.resizable()
                         .scaledToFit()
                         .frame(height: 300)
                         .clipped()
                } placeholder: {
                    Color.gray.frame(height: 300)
                }

                Text(film.title ?? "Unknown")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)

                Text("\(film.year)")
                    .font(.subheadline)
                    .padding(.top, 2)

                Text("⭐ \(String(format: "%.1f", film.rating))")
                    .font(.subheadline)
                    .foregroundColor(.yellow)

                Text(film.filmDescription ?? "")
                    .padding(.top)

                Button(action: {
                    // Save to My Films
                    PersistenceController.shared.saveContext()
                }) {
                    Text("Save to My Films")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle(film.title ?? "Unknown")
    }
}
