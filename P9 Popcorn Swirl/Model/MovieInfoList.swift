//
//  MovieInfoList.swift
//  P9 Popcorn Swirl
//
//  Created by Eric Stein on 2/18/20.
//  Copyright © 2020 Eric Stein. All rights reserved.
//

import Foundation

// This class object purpose is to hold info for the list of movies.
class MovieInfoList {
    
    //variables for movies in the iTunes store helping us to look for more details
    var id: Int64
    var title: String
    var type: String
    var artworkURL: String
    // a property to store the actual image data
    var artworkData: Data?
    
    //initializer for non optionals
    init(id: Int64, title: String, category: String, artWorkURL: String) {
        self.id = id
        self.title = title
        self.type = category
        self.artworkURL = artWorkURL
    }
    
}
