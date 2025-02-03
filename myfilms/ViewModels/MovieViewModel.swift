//
//  MovieViewModel.swift
//  myfilms
//
//  Created by Daniel Moreno Wellinski Siahaan on 03/02/2025.
//


import Foundation
import CoreData

class MovieViewModel: ObservableObject {
    @Published var movies: [Film] = []
    private let persistenceController = Persistence.shared
    private let tmdbService = TMDBService()
    
    // Fetch popular movies from TMDb API and save them to Core Data
    func fetchMovies() {
        tmdbService.fetchPopularMovies { [weak self] result in
            switch result {
            case .success(let films):
                // Save to Core Data
                self?.saveMovies(films)
            case .failure(let error):
                print("Failed to fetch movies: \(error.localizedDescription)")
            }
        }
    }
    
    // Save fetched movies to Core Data
    private func saveMovies(_ films: [Film]) {
        let context = persistenceController.container.viewContext
        films.forEach { film in
            let coreDataFilm = Film(context: context)
            coreDataFilm.id = film.id
            coreDataFilm.title = film.title
            coreDataFilm.year = film.year
            coreDataFilm.rating = film.rating
            coreDataFilm.filmDescription = film.filmDescription
            coreDataFilm.posterURL = film.posterURL
        }
        
        do {
            try context.save()
            DispatchQueue.main.async {
                self.movies = films
            }
        } catch {
            print("Failed to save movies to Core Data: \(error.localizedDescription)")
        }
    }
    
    // Fetch all movies from Core Data
    func fetchSavedMovies() {
        let context = persistenceController.container.viewContext
        let request: NSFetchRequest<Film> = Film.fetchRequest()
        
        do {
            let films = try context.fetch(request)
            self.movies = films
        } catch {
            print("Failed to fetch saved movies: \(error.localizedDescription)")
        }
    }
}
