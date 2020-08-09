//
//  SceneDelegate.swift
//  ProjectMovie
//
//  Created by Rafaela Galdino on 04/04/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = MovieTabBarController()
        window?.makeKeyAndVisible()
    }
}

