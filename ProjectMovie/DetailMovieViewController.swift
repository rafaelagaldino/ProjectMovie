//
//  DetailMovieViewController.swift
//  ProjectMovie
//
//  Created by Rafaela Galdino on 07/04/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailMovieViewController: UIViewController {
    var scrollView = UIScrollView()
    var container = UIView()
    
    var imageMovie = UIImageView()
    var poster = UIImageView()
    var titleMovie = UILabel()
    var genreLabel = UILabel()
    var sinopse = UILabel()
 
    var movie: Movie!
    var imagePoster: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
 
        addScroll()
        addContainer()
        addImageMovie()
        addPoster()
        addTitleMovie()
        addGenre()
        addSinopse()
    }

    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addScroll() {
        scrollView.isScrollEnabled = true

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func addContainer() {
        scrollView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    func addImageMovie() {
        let image = TransformsUrlToImage()
        guard let moveImage = self.movie?.backdrop_path else { return }
        imageMovie = UIImageView(image: image.baseImage(poster: moveImage))
        
        container.addSubview(imageMovie)
        
        imageMovie.translatesAutoresizingMaskIntoConstraints = false
        imageMovie.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageMovie.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 0).isActive = true
        imageMovie.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 0).isActive = true
    }
    
    func addPoster() {
        let image = TransformsUrlToImage()
        guard let posterImage = self.movie?.poster_path else { return }
        poster = UIImageView(image: image.baseImage(poster: posterImage))

        container.addSubview(poster)
        
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.topAnchor.constraint(equalTo: imageMovie.bottomAnchor, constant: -90).isActive = true
        poster.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        poster.widthAnchor.constraint(equalToConstant: 120).isActive = true
        poster.heightAnchor.constraint(equalToConstant: 170).isActive = true
    }
    
    func addTitleMovie() {
        guard let title = self.movie?.title else { return }
        titleMovie.text = title
        titleMovie.numberOfLines = 0
        titleMovie.lineBreakMode = .byWordWrapping
        titleMovie.font = UIFont(name: "Helvetica-Bold", size: 18)
        container.addSubview(titleMovie)
        
        titleMovie.translatesAutoresizingMaskIntoConstraints = false
        titleMovie.topAnchor.constraint(equalTo: imageMovie.bottomAnchor, constant: 20).isActive = true
        titleMovie.leftAnchor.constraint(equalTo: poster.rightAnchor, constant: 20).isActive = true
        titleMovie.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -10).isActive = true
    }
    
    func addGenre() {
        //guard let genre = self.movie?.genre else { return }
        genreLabel.text = "Livre"
        genreLabel.font = UIFont(name: "Helvetica", size: 12)
        container.addSubview(genreLabel)
        
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.topAnchor.constraint(equalTo: titleMovie.bottomAnchor, constant: 4).isActive = true
        genreLabel.leftAnchor.constraint(equalTo: poster.rightAnchor, constant: 20).isActive = true
    }
    
    func addSinopse() {
        guard let overview = self.movie?.overview else { return }
        sinopse.text = overview
        sinopse.textAlignment = .left
        sinopse.numberOfLines = 0
        sinopse.lineBreakMode = .byWordWrapping
        sinopse.font = UIFont(name: "Helvetica", size: 15)
        container.addSubview(sinopse)
        
        sinopse.translatesAutoresizingMaskIntoConstraints = false
        sinopse.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 20).isActive = true
        sinopse.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        sinopse.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        sinopse.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
    }
}
