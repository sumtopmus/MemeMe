//
//  SavedMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Oleksandr Iaroshenko on 08.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class SavedMemesCollectionViewController: UICollectionViewController {

    // Magic values
    private struct Defaults {
        static let MemeCell = "Meme Collection View Cell"
        static let HeightToWidthRatio: CGFloat = 9.0 / 16.0

        static let AddMemeSegue = "Add Meme"
        static let ShowMemeSegue = "Show Meme"
    }

    // MARK: - Model

    var memes = [Meme]()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        collectionView?.reloadData()
    }

    // MARK: Collection View Data Source

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Model.sharedInstance.memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Defaults.MemeCell, forIndexPath: indexPath) as! SavedMemeCollectionViewCell

        if cell.meme != Model.sharedInstance.memes[indexPath.row] {
            cell.meme = Model.sharedInstance.memes[indexPath.row]
        }

        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Defaults.ShowMemeSegue:
                let showMemeVC = segue.destinationViewController as! ShowMemeViewController
                if let indexPath = collectionView?.indexPathsForSelectedItems() as? [NSIndexPath] {
                    let cell = collectionView?.cellForItemAtIndexPath(indexPath[0]) as! SavedMemeCollectionViewCell
                    showMemeVC.memeImage = cell.memeImageView.image
                }
            default:
                break
            }
        }
    }
}