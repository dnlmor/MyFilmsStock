//
//  TMDBService.swift
//  myfilms
//
//  Created by Daniel Moreno Wellinski Siahaan on 03/02/2025.
//


import Foundation

struct TMDBService {
    
    // API Key and Base URL for TMDb API
    private let apiKey = "f33de3f78919e1673e5012917d2fd5f6"
    private let baseURL = "https://api.themoviedb.org/3"

    // The endpoint for fetching popular movies
    private let popularMoviesEndpoint = "/movie/popular"
    
    // URL session for API requests
    private let session = URLSession.shared
    
    // Function to fetch popular movies
    func fetchPopularMovies(page: Int = 1, completion: @escaping (Result<[Film], Error>) -> Void) {
        let urlString = "\(baseURL)\(popularMoviesEndpoint)?api_key=\(apiKey)&page=\(page)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                // Parse the JSON response into an array of Film models
                let decoder = JSONDecoder()
                let response = try decoder.decode(TMDBMoviesResponse.self, from: data)
                let films = response.results.map { film in
                    return Film(id: UUID(), title: film.title, year: Int16(film.release_date.prefix(4)) ?? 0, rating: film.vote_average, filmDescription: film.overview, posterURL: "https://image.tmdb.org/t/p/w500\(film.poster_path ?? "")")
                }
                completion(.success(films))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// Response model to map the TMDb JSON response
struct TMDBMoviesResponse: Codable {
    let results: [TMDBMovie]
}

struct TMDBMovie: Codable {
    let title: String
    let release_date: String
    let vote_average: Double
    let overview: String
    let poster_path: String?
}
