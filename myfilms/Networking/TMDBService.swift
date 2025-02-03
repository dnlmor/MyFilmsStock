import Foundation

class TMDBService {
    private let apiKey = "f33de3f78919e1673e5012917d2fd5f6"
    private let baseURL = "https://api.themoviedb.org/3"
    
    func fetchAllMovies(completion: @escaping (Result<[TMDBFilm], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/discover/movie?api_key=\(apiKey)&sort_by=popularity.desc")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TMDBResponse.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

struct TMDBResponse: Codable {
    let results: [TMDBFilm]
}

struct TMDBFilm: Codable {
    let title: String
    let release_date: String
    let vote_average: Double
    let overview: String
    let poster_path: String?
    let genre_ids: [Int]
    
    var posterURL: String? {
        guard let posterPath = poster_path else { return nil }
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
}
