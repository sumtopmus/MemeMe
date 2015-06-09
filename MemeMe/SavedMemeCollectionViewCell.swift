//
//  SavedMemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Oleksandr Iaroshenko on 08.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class SavedMemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView?.image = memeImage
        }
    }

    var memeImage: UIImage? {
        didSet {
            imageView?.image = memeImage
        }
    }
}