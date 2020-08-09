//
//  ViewModel.swift
//  ProjectMovie
//
//  Created by Rafaela Galdino on 05/04/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

//protocol ViewModelDelegate: class {
//func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
//}

enum ServiceError: Error {
    case decodeError(String)
}

class MovieApi {
    private let url = "http://api.themoviedb.org/3/movie/top_rated?api_key="
    private let key = "4e90c81199d5afa6190efa83e307a77a"
    
    public var movies: [Movie] = []
    var result: [Movies]?
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    var totalCount: Int {
      return total
    }
    
    var currentCount: Int {
      return movies.count
    }
    
    func movie (at index: Int) -> Movie {
      return movies[index]
    }
    
    func fetchPopularMovies(completion: @escaping (Result<Movies, ServiceError>) -> Void) {
        let request = AF.request("\(self.url)\(self.key)&language=pt-BR&page=\(currentPage)", method: .post)
            
        request.validate().responseDecodable(of: Movies.self) { response in
            switch response.result {
            case .success:
                guard let movies = response.value else { return }
                self.currentPage += 1
                completion(.success(movies))
            case .failure:
                guard let error = response.error else { return }
                completion(.failure(ServiceError.decodeError(error.localizedDescription)))
            }
        }        
    }
}
