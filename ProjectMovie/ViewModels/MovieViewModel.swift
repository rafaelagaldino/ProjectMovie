//
//  ViewModels.swift
//  ProjectMovie
//
//  Created by Rafaela Galdino on 02/07/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//
import Foundation
import RxSwift

protocol ViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
}

class MovieViewModel {
    private let request = MovieApi()
    private var currentPage = 1
    private var isFetchInProgress = false
    private var total = 0

    public var movies: [Movie] = []

    public weak var delegate: ViewModelDelegate?

    public let favorite = FavoriteMovie.shared

    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return movies.count
    }

    func requestMovieApi(){
        guard !self.isFetchInProgress else { return }
        self.isFetchInProgress = true
        
        request.fetchPopularMovies() { result in
            switch result {
            case .success(let movies):
                let movies = movies
                self.total = movies.total_results
                self.movies.append(contentsOf: movies.results)
                let teste = self.favorite.getMovie() as? [Movie]
                for (index, item) in self.movies.enumerated() {
                    if index < teste?.count ?? 0 {
                        self.movies[index].isFavorite = teste?[index].isFavorite
                    }
                }
                if teste?.count ?? 0 < self.movies.count {
                    self.favorite.setMovie(self.movies)
                }
                    
                self.currentPage += 1
                self.isFetchInProgress = false
                
                if movies.page > 1 {
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: movies.results)
                    self.delegate?.onFetchCompleted(with: indexPathsToReload)
                } else {
                    self.delegate?.onFetchCompleted(with: .none)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
        let startIndex = movies.count - newMovies.count
        let endIndex = startIndex + newMovies.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
