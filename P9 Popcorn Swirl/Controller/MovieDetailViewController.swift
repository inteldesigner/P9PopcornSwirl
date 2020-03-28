//
//  MovieDetailViewController.swift
//  P9 Popcorn Swirl
//
//  Created by Eric Stein on 2/21/20.
//  Copyright © 2020 Eric Stein. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol ModalHandler {
    func modalDismissed()
}

class MovieDetailViewController: UIViewController {
    
    var movieId: Int64!
    var movieNote: String?
    private var movie: Movie?
    var delegate: ModalHandler?
    
//    var bannerView: GADBannerView!
//    ID: ca-app-pub-4715423833680948~2058749913
//    BannerID = "ca-app-pub-4715423833680948/2797116513"
    
    
    // textview inside add note alert controller
    let textView = UITextView(frame: CGRect.zero)


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    @IBOutlet weak var bookmarkOutlet: UIButton!
    @IBOutlet weak var watchOutlet: UIButton!
    @IBOutlet weak var addNoteOutlet: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
         updateBookmarkOutlet()
              if bookmarkOutlet.isSelected || watchOutlet.isSelected {
                  createOrUpdateMovie(status: false, note: nil)
              } else {
                  deleteMovie()
              }
    }
    
    @IBAction func watchOutletTapped(_ sender: Any) {
        updateWatchOutlet()
             if bookmarkOutlet.isSelected || watchOutlet.isSelected {
                 createOrUpdateMovie(status: true, note: nil)
             } else {
                 deleteMovie()
             }
    }
    
    @IBAction func storeButtonTapped(_ sender: Any) {
      print(movie!.sourceURL)
              openURL(sourceUrl: movie!.sourceURL)
          }
    
    @IBAction func addNoteButtonTapped(_ sender: Any) {
         addNoteAction()
    }
    
      // MARK: - Update UI
        func updateBookmarkOutlet() {
            bookmarkOutlet.isSelected = !bookmarkOutlet.isSelected
            bookmarkOutlet.tintColor = bookmarkOutlet.isSelected ? UIColor.systemPink : UIColor.darkGray
            if watchOutlet.isSelected {
                watchOutlet.isSelected = false
                watchOutlet.tintColor = UIColor.darkGray
            }
            updateNoteOutlet()
        }
        
        func updateWatchOutlet() {
            watchOutlet.isSelected = !watchOutlet.isSelected
            watchOutlet.tintColor = watchOutlet.isSelected ? UIColor.systemPink : UIColor.darkGray
            updateNoteOutlet()
            if bookmarkOutlet.isSelected {
                bookmarkOutlet.isSelected = false
                bookmarkOutlet.tintColor = UIColor.darkGray
            }
        }
        
        func updateNoteOutlet() {
            addNoteOutlet.backgroundColor = watchOutlet.isSelected ? UIColor.systemPink : UIColor.init(cgColor: #colorLiteral(red: 0.6188722253, green: 0.8441727757, blue: 0.9673594832, alpha: 1))
            
            if watchOutlet.isSelected == true {
                let addButtonTitle = ifWeHaveNote().1
                addNoteOutlet.setTitle(addButtonTitle, for: .normal)
                addNoteOutlet.titleLabel?.font = addNoteOutlet.titleLabel?.font.withSize(24)
                addNoteOutlet.isEnabled = true
            } else {
                addNoteOutlet.setTitle("Add movie to Watched list to attach a note to it", for: .normal)
                addNoteOutlet.titleLabel?.font = addNoteOutlet.titleLabel?.font.withSize(15)
                addNoteOutlet.isEnabled = false
            }
        }
        
        // to update UI when opening the movie details from any root screen
        func updateUI() {
            if let alreadySavedMovie = CoreData.shared.MovieAlreadySaved(movieId: movieId) {
                alreadySavedMovie.status ? updateWatchOutlet() : updateBookmarkOutlet()
                
            }
        }
        
        func populateMovie() {
            guard let movie = self.movie else {
                return
            }
            
            movieTitle.text = movie.title
            typeLabel.text = movie.type
            
            // FIXME: - get the first four charachters for the release year using NSAttributedString

            releaseYearLabel.text = movie.releaseDate?.maxLength(length: 10)
            descriptionTextView.text = movie.movieDescription
            
            
            if let imageUrl = URL(string: movie.artworkURL) {
                Itunes.getImage(imageUrl: imageUrl) { (success, imageData) in
                    if success, let imageData = imageData ,
                        let moviePic = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.imageView.image = moviePic
                        }
                    }
                }
            }
        }
    
    // alert in case there is no internet access
        func presentNoDataAlert(title: String?, message: String?) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Got it", style: .cancel)
            alertController.addAction(dismissAction)
            present(alertController, animated: true)
        }
        
        // MARK: - CoreData Functionality
        func deleteMovie() {
            if let alreadySavedMovie = CoreData.shared.MovieAlreadySaved(movieId: movieId) {
            // delete movie
                CoreData.shared.context.delete(alreadySavedMovie)
                CoreData.shared.appDelegate.saveContext()
            }
        }
        
        // status = false means movie is bookmarked, status == true means movie is add to watched list
        func createOrUpdateMovie(status: Bool, note: String?) {
            if let alreadySavedMovie = CoreData.shared.MovieAlreadySaved(movieId: movieId) {
                // update movie
                alreadySavedMovie.status = status
                if note != nil { alreadySavedMovie.note = note }
                CoreData.shared.appDelegate.saveContext()
            } else {
                // create movie
                let movie = SavedMovies(entity: SavedMovies.entity(), insertInto: CoreData.shared.context)
                
                movie.id = self.movie!.id
                movie.title = self.movie!.title
                movie.type = self.movie!.type
                movie.artworkURL = self.movie!.artworkURL
                movie.artworkData = self.movie?.artworkData
                movie.status = status
                movie.creationDate = Date()
                if note != nil { movie.note = note }
                CoreData.shared.appDelegate.saveContext()
            }
        }
        
        // MARK: - Networking
        func loadData() {
            Itunes.getMovie(id: movieId) { (success, movie) in
                if success, let movie = movie {
                    self.movie = movie
                    DispatchQueue.main.async {
                        self.populateMovie()
                    }
                } else {
                    self.presentNoDataAlert(title: "Oops, Something happened..", message: "Couldn't load movie details")
                }
            }
        }
        
        func openURL(sourceUrl: String?) {
            if let sourceUrl = sourceUrl, let url = URL(string: sourceUrl) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                presentNoDataAlert(title: "Oops, Something happened..", message: "Can't take you to the source")
            }
        }

        // MARK: - Configuration
        override func viewDidLoad() {
            super.viewDidLoad()
            loadData()
            configure()
            configureAdUnit()

        }
        
    
        func configure() {
            updateNoteOutlet()
            updateUI()
            
            //button rounded
            roundedButton(button: storeButton)
            roundedButton(button: addNoteOutlet)
           
        }
    
    func roundedButton(button: UIButton) {
          var roundButton = BetterButton()
          roundButton.setButton(button)
          roundButton.roundButton()
      }
        
//    google add
        func configureAdUnit() {

            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())

        }
        
     

        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(true)
            delegate?.modalDismissed()
        }
    }

extension MovieDetailViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("receive Ad")
    }
    
    func adView(_bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError){
        print(error)
    }
    
}


    // MARK: - Add note functionality
    extension MovieDetailViewController: UITextViewDelegate {
        
        func ifWeHaveNote() -> (String,String,String) {
            var titles = ("","","")
            if let alreadySavedMovie = CoreData.shared.MovieAlreadySaved(movieId: movieId),
                alreadySavedMovie.note != nil {
                titles.0 = "Your Note"
                titles.1 = "Edit Note"
                titles.2 = alreadySavedMovie.note!
            } else {
                titles.0 = "Add New Note"
                titles.1 = "Add Note"
                titles.2 = "Write your note here"
            }
            return titles
        }
            
        func addNoteAction() {
            let (alertControllerTitle, alertControllerActionTitle, textViewText) = ifWeHaveNote()
            let alert = UIAlertController(title: alertControllerTitle, message: "", preferredStyle: .alert)
            
            // increse the height of alert controller to accommodate UITextView
            let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200)
            alert.view.addConstraint(height)
            
            
            let addNoteAction = UIAlertAction(title: alertControllerActionTitle, style: .default) { (action) in
                self.createOrUpdateMovie(status: true, note: self.textView.text)
                self.updateNoteOutlet()
                alert.view.removeObserver(self, forKeyPath: "bounds")
            }
            
            addNoteAction.isEnabled = false
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                alert.view.removeObserver(self, forKeyPath: "bounds")
            }
            
            alert.view.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
            NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: textView, queue: OperationQueue.main) { (notification) in
                addNoteAction.isEnabled = self.fetchInput(textViewInput: self.textView) != nil ? true : false
            }
            
            textView.backgroundColor    = UIColor.white
            textView.textContainerInset = UIEdgeInsets.init(top: 8, left: 5, bottom: 8, right: 5)
            textView.font               = UIFont(name: "Helvetica", size: 15)
            textView.backgroundColor    = UIColor.white
            textView.layer.borderColor  = UIColor.lightGray.cgColor
            textView.layer.borderWidth  = 1.0
            //placeholder
            textView.textColor          = textViewText == "Write your note here" ? UIColor.lightGray : UIColor.black
            textView.text               = textViewText
            textView.delegate           = self
            
            
            
            alert.view.addSubview(textView)
            alert.addAction(addNoteAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
            
        }
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "bounds"{
                if let rect = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgRectValue {
                    let margin:CGFloat = 8.0
                    textView.frame = CGRect.init(x: rect.origin.x + margin, y: rect.origin.y + margin + 40, width: rect.width - 2*margin, height: rect.height / 2)
                    textView.bounds = CGRect.init(x: rect.origin.x + margin, y: rect.origin.y + margin, width: rect.width - 2*margin, height: rect.height / 2)
                }
            }
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
        
            // function for trimming all white characters because there's a possibility that user just keeps typing spaces without meaningful text.
            private func fetchInput(textViewInput: UITextView) -> String? {
                if let caption = textViewInput.text?.trimmingCharacters(in: .whitespaces) {
                    return caption.count > 0 ? caption : nil
                }
                return nil
            }
            
        }

        // limit the number of characters in releaseYear label for only release date
        extension String {
           func maxLength(length: Int) -> String {
               var limitCharacters = self
               let nsString = limitCharacters as NSString
               if nsString.length >= length {
                   limitCharacters = nsString.substring(with:
                       NSRange(
                        location: 0,
                        length: nsString.length > length ? length : nsString.length)
                   )
               }
               return  limitCharacters
           }
        }


