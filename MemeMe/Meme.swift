//
//  Meme.swift
//  MemeMe
//
//  Created by Oleksandr Iaroshenko on 07.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//@objc(Meme)
class Meme: NSManagedObject {

    // MARK: - Persistent properties

    @NSManaged var pathToEditedImage: String
    @NSManaged var topText: String
    @NSManaged var bottomText: String

    // MARK: - Initializers

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    init(context: NSManagedObjectContext, pathToEditedImage: String, topText: String, bottomText: String) {
        let entity =  NSEntityDescription.entityForName(Model.Defaults.MemeEntityName, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)

        self.pathToEditedImage = pathToEditedImage
        self.topText = topText
        self.bottomText = bottomText
    }
}