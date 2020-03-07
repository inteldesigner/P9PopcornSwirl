//
//  CoreData.swift
//  P9 Popcorn Swirl
//
//  Created by Eric Stein on 2/18/20.
//  Copyright © 2020 Eric Stein. All rights reserved.
//

import UIKit
import CoreData

class CoreData {
    
    static let shared = CoreData()
    
    private init() {
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedRC: NSFetchedResultsController<SavedMovies>!
    
    
    func refreshWith(watchedMoviesList: Bool) {
        let request = SavedMovies.fetchRequest() as NSFetchRequest<SavedMovies>
        request.predicate = NSPredicate(format: "status = %@", NSNumber(value: watchedMoviesList))
        
        let sort = NSSortDescriptor(key: #keyPath(SavedMovies.creationDate), ascending: true)
        request.sortDescriptors = [sort]
        fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Couldn't fetch. \(error), \(error.userInfo)")
        }
    }
    
}

extension CoreData {
    
    func MovieAlreadySaved(movieId: Int64) -> SavedMovies? {
        let request = SavedMovies.fetchRequest() as NSFetchRequest<SavedMovies>
            request.predicate = NSPredicate(format: "id == %d", movieId)
        do {
            return try context.fetch(request).first
        } catch let error as NSError {
            print("could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
}
