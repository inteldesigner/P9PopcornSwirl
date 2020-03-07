//
//  Movie.swift
//  P9 Popcorn Swirl
//
//  Created by Eric Stein on 2/18/20.
//  Copyright © 2020 Eric Stein. All rights reserved.
//


import Foundation


//Holding the Infos: This class will serve the MovieDetailViewController of a movie subclass of the MovieInfoList.

class Movie: MovieInfoList {
    
    var releaseDate: String?
    var movieDescription: String?
    
    // Property to take the user to the source
    var sourceURL: String
    
    init(id: Int64, title: String, category: String, artWorkURL: String, sourceURL: String) {
        self.sourceURL = sourceURL
        super.init(id: id, title: title, category: category, artWorkURL: artWorkURL)
    }

}
