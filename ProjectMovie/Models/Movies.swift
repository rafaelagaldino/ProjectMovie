//
//  Movies.swift
//  ProjectMovie
//
//  Created by Rafaela Galdino on 04/04/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import Foundation

struct Movies: Codable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}

struct Movie: Codable {
    var adult: Bool
    var backdrop_path: String?
    var genre_ids: [Int]
    var id: Int
    var original_language: String
    var original_title: String
    var overview: String
    var popularity: Double
    var poster_path: String
    var release_date: String
    var title: String
    var video: Bool
    var vote_average: Double
    var vote_count: Int
    var isFavorite: Bool?
}

public class FavoriteMovie {
    let defaults = UserDefaults.standard
    static var shared: FavoriteMovie = FavoriteMovie()
    
    func setMovie(_ movie: [Movie]) {
        let data = movie.map { try? JSONEncoder().encode($0) }
        defaults.set(data, forKey: "movie")
        defaults.synchronize()
    }
    
    func getMovie() -> [Movie]? {
        guard let encodedData = defaults.array(forKey: "movie") as? [Data] else { return [] }
        return encodedData.map { try! JSONDecoder().decode(Movie.self, from: $0) }
    }
    
    func removeMovie() {
        defaults.removePersistentDomain(forName: "movie")
        defaults.synchronize()
    }
}
