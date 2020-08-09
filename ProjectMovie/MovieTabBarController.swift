//
//  MovieTabBarController.swift
//  ProjectMovie
//
//  Created by Rafaela Galdino on 02/07/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit

class MovieTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let firstViewController = UINavigationController(rootViewController: MovieViewController())
        firstViewController.tabBarItem  = UITabBarItem(tabBarSystemItem: .recents, tag: 0)
        
        let secondViewController = UINavigationController(rootViewController: FavoriteViewController())
        secondViewController.tabBarItem  = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)

        let tabBarList = [firstViewController, secondViewController]

        viewControllers = tabBarList
    }

}
