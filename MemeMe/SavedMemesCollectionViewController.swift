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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(SavedMemeCollectionViewCell.self, forCellWithReuseIdentifier: Defaults.MemeCell)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes

        collectionView?.reloadData()

        if memes.count == 0 {
            performSegueWithIdentifier(Defaults.AddMemeSegue, sender: self)
        }
    }

    // MARK: Collection View Data Source

//    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Defaults.MemeCell, forIndexPath: indexPath) as! SavedMemeCollectionViewCell
    
        cell.memeImage = memes[indexPath.row].getMeme()

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
                if let indexPath = collectionView?.indexPathsForSelectedItems().first as? NSIndexPath {
                    showMemeVC.meme = memes[indexPath.row]
                }
            default:
                break
            }
        }
    }
}