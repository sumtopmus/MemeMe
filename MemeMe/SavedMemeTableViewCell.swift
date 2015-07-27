//
//  SavedMemeTableViewCell.swift
//  MemeMe
//
//  Created by Oleksandr Iaroshenko on 08.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class SavedMemeTableViewCell: UITableViewCell {

    // MARK: Magic values

    private struct Defaults {
        static let MemeFontName = "HelveticaNeue-CondensedBlack"
        static let MemeFontSize: CGFloat = 12
    }

    // MARK: - Actions and Outlets

    @IBOutlet weak var memeImageView: UIImageView! {
        didSet {
            setMemeImage()
        }
    }

    @IBOutlet weak var topTextLabel: UILabel! {
        didSet {
            topTextLabel.font = UIFont(name: Defaults.MemeFontName, size: Defaults.MemeFontSize)!
            topTextLabel?.text = meme?.topText
        }
    }

    @IBOutlet weak var bottomTextLabel: UILabel! {
        didSet {
            bottomTextLabel.font = UIFont(name: Defaults.MemeFontName, size: Defaults.MemeFontSize)!
            bottomTextLabel?.text = meme?.bottomText
        }
    }

    // MARK: - Properties

    var meme: Meme? {
        didSet {
            topTextLabel?.text = meme!.topText
            bottomTextLabel?.text = meme!.bottomText

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