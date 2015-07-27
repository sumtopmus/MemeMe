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
    }

    // MARK: - Singleton pattern

    static let sharedInstance = Model()

    // MARK: - Model

    var memes = [Meme]()

    private init() {
        fetchAllMemes()
    }

    func fetchAllMemes() {
        let fetchRequest = NSFetchRequest(entityName: Defaults.MemeEntityName)
        var error: NSError?
        if let results: [AnyObject] = CoreDataStackManager.sharedInstance.managedObjectContext?.executeFetchRequest(fetchRequest, error: &error) {
            memes = results as! [Meme]
        }
    }
}