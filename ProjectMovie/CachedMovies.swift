//
//  CachedMovies.swift
//  ProjectMovie
//
//  Created by Rafaela Galdino on 07/08/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import Foundation

class Favorites: ObservableObject {
    private var title: Set<String>

    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favorites"

    init() {
        // load our saved data

        // still here? Use an empty array
        self.title = []
    }

    // returns true if our set contains this resort
    func contains(_ movie: String) -> Bool {
        title.contains(movie)
    }

    // adds the resort to our set, updates all views, and saves the change
    func add(_ movie: String) {
        objectWillChange.send()
        title.insert(movie)
        save()
    }

    // removes the resort from our set, updates all views, and saves the change
    func remove(_ movie: String) {
        objectWillChange.send()
        title.remove(movie)
        save()
    }

    func save() {
        // write out our data
    }

}
