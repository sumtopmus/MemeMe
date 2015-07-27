//
//  SavedMemesTableViewController.swift
//  MemeMe
//
//  Created by Oleksandr Iaroshenko on 08.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit
import CoreData

class SavedMemesTableViewController: UITableViewController {

    // MARK: - Magic values
    private struct Defaults {
        static let MemeCell = "Meme Table View Cell"
        static let CellHeight: CGFloat = 80.0
        static let HeightToWidthRatio: CGFloat = 9.0 / 16.0

        static let AddMemeSegue = "Add Meme"
        static let ShowMemeSegue = "Show Meme"
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    // MARK: - Table View Data Source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.sharedInstance.memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Defaults.MemeCell, forIndexPath: indexPath) as! SavedMemeTableViewCell

        if cell.meme != Model.sharedInstance.memes[indexPath.row] {
            cell.meme = Model.sharedInstance.memes[indexPath.row]
        }

        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Defaults.CellHeight
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Remove image from disk
            let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as! String
            let absoluteFilePath = documentsDirectory.stringByAppendingPathComponent(Model.sharedInstance.memes[indexPath.row].pathToEditedImage)
            NSFileManager.defaultManager().removeItemAtPath(absoluteFilePath, error: NSErrorPointer())

            // Remove object from CoreData
            CoreDataStackManager.sharedInstance.managedObjectContext?.deleteObject(Model.sharedInstance.memes[indexPath.row])
            CoreDataStackManager.sharedInstance.saveContext()

            // Remove object from memory
            Model.sharedInstance.memes.removeAtIndex(indexPath.row)

            // Remove cell from TableView
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Defaults.ShowMemeSegue:
                let showMemeVC = segue.destinationViewController as! ShowMemeViewController
                if let indexPath = tableView.indexPathForSelectedRow() {
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as! SavedMemeTableViewCell
                    showMemeVC.memeImage = cell.memeImageView.image
                }
            default:
                break
            }
        }
    }
}