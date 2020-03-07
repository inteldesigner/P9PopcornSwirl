//
//  SavedMovies+CoreDataProperties.swift
//  P9 Popcorn Swirl
//
//  Created by Eric Stein on 2/18/20.
//  Copyright © 2020 Eric Stein. All rights reserved.
//

import Foundation
import CoreData


extension SavedMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedMovies> {
        return NSFetchRequest<SavedMovies>(entityName: "SavedMovies")
    }

    @NSManaged public var artworkData: Data?
    @NSManaged public var artworkURL: String
    @NSManaged public var creationDate: Date
    @NSManaged public var type: String
    @NSManaged public var id: Int64
    @NSManaged public var note: String?
    @NSManaged public var status: Bool
    @NSManaged public var title: String

}
