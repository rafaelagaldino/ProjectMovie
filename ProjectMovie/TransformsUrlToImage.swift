//
//   TransformsUrlToImage.swift
//  ProjectMovie
//
//  Created by Rafaela Galdino on 08/04/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit

class TransformsUrlToImage {
    private let urlImage = "https://image.tmdb.org/t/p/w500"

    public func baseImage(poster: String) -> UIImage {
        let pathImage = "\(urlImage)\(poster)"
        let urlImage = URL(string: pathImage)
        let bytes: Data = try! Data(contentsOf: urlImage!)        
        let image = UIImage(data: bytes)
        return image!
    }
}
