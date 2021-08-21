//
//  AlbumsFetcher.swift
//  AlbumsFetcher
//
//  Created by Kah Seng Lee on 14/08/2021.
//

import Foundation

struct ITunesResult: Codable {
    let results: [Album]
}

struct Album: Codable, Hashable {
    let collectionId: Int
    let collectionName: String
    let collectionPrice: Double
}

struct AlbumsFetcher {
    
    enum AlbumsFetcherError: Error {
        case invalidURL
        case missingData
    }
    
    /// Make network request using closure-based `URLSession` API
    static func fetchAlbums(completion: @escaping (Result<[Album], Error>) -> Void) {
        
        // Create URL
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=album") else {
            completion(.failure(AlbumsFetcherError.invalidURL))
            return
        }
        
        // Create URL session data task
        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(AlbumsFetcherError.missingData))
                return
            }
            
            do {
                // Parse the JSON data
                let iTunesResult = try JSONDecoder().decode(ITunesResult.self, from: data)
                completion(.success(iTunesResult.results))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
        
        
    }
    
    
    /// Make network request using checked continuation
    static func fetchAlbumWithContinuation() async throws -> [Album] {
        
        // Bridge between synchronous and asynchronous code using continuation
        let albums: [Album] = try await withCheckedThrowingContinuation({ continuation in
            
            // Async task execute the `fetchAlbums(completion:)` function
            fetchAlbums { result in
                
                switch result {
                case .success(let albums):
                    // Resume with fetched albums
                    continuation.resume(returning: albums)
                    
                case .failure(let error):
                    // Resume with error
                    continuation.resume(throwing: error)
                }
            }
        })
        
        return albums
    }
    
    
    /// Make network request using async `URLSession` API
    static func fetchAlbumWithAsyncURLSession() async throws -> [Album] {

        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=album") else {
            throw AlbumsFetcherError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let iTunesResult = try JSONDecoder().decode(ITunesResult.self, from: data)
        return iTunesResult.results
    }

}
