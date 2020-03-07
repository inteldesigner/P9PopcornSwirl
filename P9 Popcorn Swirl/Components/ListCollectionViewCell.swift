//
//  ListCollectionViewCell.swift
//  P9 Popcorn Swirl
//
//  Created by Eric Stein on 2/18/20.
//  Copyright © 2020 Eric Stein. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    //title and genre of movie
    func populate(movieList: MovieInfoList) {
        titleLabel.text = movieList.title
        categoryLabel.text = movieList.type
    }
    
    func populateWith(savedMovies: SavedMovies) {
        titleLabel.text = savedMovies.title
        categoryLabel.text = savedMovies.type
    }
    
    func setImage(image: UIImage?) {
        ImageView.image = image
    }
    
    override func awakeFromNib() {
         super.awakeFromNib()
         // Initialization code
     }  

}
