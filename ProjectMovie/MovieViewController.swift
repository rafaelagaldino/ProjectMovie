//
//  ViewController.swift
//  ProjectMovie
//
//  Created by Rafaela Galdino on 04/04/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit
import RxSwift

class MovieViewController: UIViewController {
    var collectionView: UICollectionView!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredMovie: [Movie] = []
    var movie: [Movie] = []
    var viewModel: MovieViewModel!

    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    let favorite = FavoriteMovie.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.register(MovieViewCell.self, forCellWithReuseIdentifier: MovieViewCell.reuseIdentifier)
        view.addSubview(collectionView)

        setupCollectionConstraints()
        
        viewModel = MovieViewModel()
        viewModel.delegate = self
        self.viewModel.requestMovieApi()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.movie = favorite.getMovie() ?? []
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true

        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 17)]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func setupCollectionConstraints() {
        collectionView.anchor(
            top: self.view.topAnchor,
            leading: self.view.leadingAnchor,
            bottom: self.view.bottomAnchor,
            trailing: self.view.trailingAnchor)
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredMovie = viewModel.movies.filter { movie in
            return movie.title.lowercased().contains(searchText.lowercased())
        }
      
        collectionView.reloadData()
    }
}


extension MovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredMovie.count
        }
        return self.viewModel.totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieViewCell.reuseIdentifier, for: indexPath) as! MovieViewCell
        if isLoadingCell(for: indexPath) {
            cell.posterImage.image = UIImage(named: "")
        } else {
            if isFiltering {
                let image = TransformsUrlToImage()
                cell.posterImage.image = image.baseImage(poster: filteredMovie[indexPath.row].poster_path)
                cell.titleLabel.text = filteredMovie[indexPath.row].title
            } else {
                let image = TransformsUrlToImage()
                cell.posterImage.image = image.baseImage(poster: viewModel.movies[indexPath.row].poster_path)
                cell.titleLabel.text = viewModel.movies[indexPath.row].title
                //self.movie = favorite.getMovie() ?? []
                cell.favoriteButton.tintColor = viewModel.movies[indexPath.row].isFavorite ?? false ? UIColor.yellow : UIColor.lightGray
            }
            cell.delegate = self
        }
        return cell
    }
}

extension MovieViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
}

extension MovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
        let detail = DetailMovieViewController()
        if isFiltering {
            detail.movie = filteredMovie[indexPath.row]
        } else {
            detail.movie = viewModel.movies[indexPath.row]
        }
        navigationController?.pushViewController(detail, animated: true)
    }
}

extension MovieViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            self.viewModel.requestMovieApi()
        }
    }
}

extension MovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margins: CGFloat = 24
        let width = (view.frame.width / 2) - margins
        return CGSize(width: width, height: MovieViewCell.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 80.0)
    }

}

extension MovieViewController: ViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            collectionView.reloadData()
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        collectionView.reloadItems(at: indexPathsToReload)
    }
}

extension MovieViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems 
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

extension MovieViewController: FavoriteMovieProtocol {
    func someMethodIWantToCall(cell: UICollectionViewCell) {
        guard let indexPathTapped = collectionView.indexPath(for: cell) else { return }
        
        let isFavorite = viewModel.movies[indexPathTapped.row].isFavorite
        
        viewModel.movies = favorite.getMovie() ?? []
        viewModel.movies[indexPathTapped.row].isFavorite = !(isFavorite ?? false)

        favorite.removeMovie()
        favorite.setMovie(viewModel.movies)
        collectionView.reloadItems(at: [indexPathTapped])
    }
}
