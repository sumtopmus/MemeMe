//
//  SavedMemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Oleksandr Iaroshenko on 08.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class SavedMemeCollectionViewCell: UICollectionViewCell {

    // MARK: - Actions and Outlets

    @IBOutlet weak var memeImageView: UIImageView! {
        didSet {
            setMemeImage()
        }
    }

    // MARK: - Properties

    var meme: Meme? {
        didSet {
            setMemeImage()
        }
    }

    // MARK: - Auxiliary methods

    private func setMemeImage() {
        if let imageView = memeImageView, meme = meme {
            meme.loadImage { image in
                if self.meme?.pathToEditedImage == meme.pathToEditedImage {
                    imageView.image = image
                }
            }
        }
    }
}