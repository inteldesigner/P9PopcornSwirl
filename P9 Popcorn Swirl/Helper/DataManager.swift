//
//  DataManager.swift
//  P9 Popcorn Swirl
//
//  Created by Eric Stein on 2/18/20.
//  Copyright © 2020 Eric Stein. All rights reserved.
//

import Foundation

// The data manager will be responsible for holding the data and providing it when needed for the UI of the app.
class DataManager {
    
    // This class will follow the singleton code design pattern to allow us to use a single instance of DataManager object to provide data throughout the whole application.
    static let shared = DataManager()
    
    private init() {
    }
    
    // Sample data to represent the movie list
    lazy var movieList: [MovieInfoList] = {
        var list = [MovieInfoList]()
        
        for i in 0..<10 {
            let movie = MovieInfoList(id: 486040195, title: "Movie is", category: "loading...", artWorkURL: "")
            list.append(movie)
        }
       return list
    }()
    
}
