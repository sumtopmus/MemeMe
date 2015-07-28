//
//  Model.swift
//  MemeMe
//
//  Created by Oleksandr Iaroshenko on 23.07.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import Foundation
import CoreData

class Model {

    // MARK: - Magic values

    struct Defaults {
        static let MemeEntityName = "Meme"
        static let MemeSortingKey = "timeStamp"
    }

    // MARK: - Singleton pattern

    static let sharedInstance = Model()

    private init() {
        content?.performFetch(nil)
    }

    // MARK: - Model

    var content: NSFetchedResultsController? = {
        let fetchRequest = NSFetchRequest(entityName: Defaults.MemeEntityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Defaults.MemeSortingKey, ascending: true)]

        var result: NSFetchedResultsController?
        if let context = CoreDataManager.sharedInstance.context {
            result =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }

        return result
    }()
}