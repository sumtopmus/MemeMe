//
//  SavedMemesTableViewController.swift
//  MemeMe
//
//  Created by Oleksandr Iaroshenko on 08.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit
import CoreData

class SavedMemesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

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

        Model.sharedInstance.content?.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    // MARK: - NSFetchResultsControllerDelegate methods

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        // No implementation
    }

    func controller(controller: NSFetchedResultsController, didChangeObject object: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        default:
            return
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

    // MARK: - Table View Data Source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = Model.sharedInstance.content!.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Defaults.MemeCell, forIndexPath: indexPath) as! SavedMemeTableViewCell

        let meme = Model.sharedInstance.content!.objectAtIndexPath(indexPath) as! Meme
        if cell.meme != meme {
            cell.meme = meme
        }

        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Defaults.CellHeight
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let meme = Model.sharedInstance.content!.objectAtIndexPath(indexPath) as! Meme

            // Remove image from disk
            let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as! String
            let absoluteFilePath = documentsDirectory.stringByAppendingPathComponent(meme.pathToEditedImage)
            NSFileManager.defaultManager().removeItemAtPath(absoluteFilePath, error: nil)

            // Remove object from CoreData
            CoreDataManager.sharedInstance.context?.deleteObject(meme)
            CoreDataManager.sharedInstance.saveContext()
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