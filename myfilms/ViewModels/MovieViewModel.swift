import Foundation
import CoreData

class MovieViewModel: ObservableObject {
    @Published var movies: [Film] = []
    private let persistenceController = PersistenceController.shared
    private let tmdbService = TMDBService()

    func fetchMovies() {
        tmdbService.fetchAllMovies { [weak self] result in
            switch result {
            case .success(let films):
                self?.saveMoviesWithoutDuplicates(films)
            case .failure(let error):
                print("Failed to fetch movies: \(error.localizedDescription)")
            }
        }
    }

    private func saveMoviesWithoutDuplicates(_ films: [TMDBFilm]) {
        let context = persistenceController.container.viewContext
        let request: NSFetchRequest<Film> = Film.fetchRequest()

        do {
            let existingMovies = try context.fetch(request)
            let existingTitles = Set(existingMovies.compactMap { $0.title })

            let newMovies = films.filter { !existingTitles.contains($0.title) }

            newMovies.forEach { film in
                let coreDataFilm = Film(context: context)
                coreDataFilm.id = UUID()
                coreDataFilm.title = film.title
                coreDataFilm.year = Int16(film.release_date.prefix(4)) ?? 0
                coreDataFilm.rating = film.vote_average
                coreDataFilm.filmDescription = film.overview
                coreDataFilm.posterURL = film.posterURL
                coreDataFilm.genre = "Unknown"
            }

            try context.save()
            fetchSavedMovies()
        } catch {
            print("Failed to save movies to Core Data: \(error.localizedDescription)")
        }
    }

    func fetchSavedMovies() {
        let context = persistenceController.container.viewContext
        let request: NSFetchRequest<Film> = Film.fetchRequest()

        do {
            let films = try context.fetch(request)
            DispatchQueue.main.async {
                self.movies = films
            }
        } catch {
            print("Failed to fetch saved movies: \(error.localizedDescription)")
        }
    }

    func sortedMovies() -> [Film] {
        return movies.sorted { $0.year > $1.year }
    }
}
