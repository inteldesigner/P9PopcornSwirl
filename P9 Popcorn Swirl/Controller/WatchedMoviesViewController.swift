//
//  WatchedMoviesViewController.swift
//  P9 Popcorn Swirl
//
//  Created by Eric Stein on 2/18/20.
//  Copyright © 2020 Eric Stein. All rights reserved.
//

import UIKit

class WatchedMoviesViewController: UIViewController, ModalHandler {
    
    private var selected: IndexPath?

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!

    
      override func viewDidLoad() {
            super.viewDidLoad()
            configure()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            CoreData.shared.refreshWith(watchedMoviesList: true)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

        func configure() {
            registerCell()
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionViewFlowLayout.scrollDirection = .vertical
            CoreData.shared.refreshWith(watchedMoviesList: true)
        }

        private func registerCell() {
            let cell = UINib(nibName: "ListCollectionViewCell", bundle: nil)
            collectionView.register(cell, forCellWithReuseIdentifier: "movieListCell")
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showMovieDetails",
                let movieDetailViewController = segue.destination as? MovieDetailViewController {
                let savedMovie = CoreData.shared.fetchedRC.object(at: selected!)
                movieDetailViewController.movieId = savedMovie.id
                movieDetailViewController.movieNote = savedMovie.note
                movieDetailViewController.delegate = self
            }
        }
        
        func modalDismissed() {
            CoreData.shared.refreshWith(watchedMoviesList: true)
            self.collectionView.reloadData()

        }
    }

    extension WatchedMoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return CoreData.shared.fetchedRC.fetchedObjects?.count ?? 0
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieListCell", for: indexPath) as! ListCollectionViewCell

            if let savedMovie = CoreData.shared.fetchedRC?.object(at: indexPath) {
                cell.populateWith(savedMovies: savedMovie)
                if let data = savedMovie.artworkData {
                    cell.setImage(image: UIImage(data: data))
                } else if let imageURL = URL(string: savedMovie.artworkURL) {
                    Itunes.getImage(imageUrl: imageURL, completion: { (success, imageData) in
                        if success, let imageData = imageData,
                            let artwork = UIImage(data: imageData) {
                            savedMovie.artworkData = imageData
                            DispatchQueue.main.async {
                                cell.setImage(image: artwork)
                            }
                        }
                    })
                }
                return cell
            }
            return UICollectionViewCell()
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            selected = indexPath
            self.performSegue(withIdentifier: "showMovieDetails", sender: self)
        }
    }

    extension WatchedMoviesViewController: UICollectionViewDelegateFlowLayout {

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let w = collectionView.frame.size.width
            return CGSize(width: (w - 20)/2, height: 290)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 20
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 30
        }
    }

