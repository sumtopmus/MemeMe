//
//  SavedMemeTableViewCell.swift
//  MemeMe
//
//  Created by Oleksandr Iaroshenko on 08.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class SavedMemeTableViewCell: UITableViewCell {

    private struct Defaults {
        static let MemeFontName = "HelveticaNeue-CondensedBlack"
        static let MemeFontSize: CGFloat = 12
    }

    @IBOutlet weak var memeImageView: UIImageView! {
        didSet {
            memeImageView?.image = meme?.getMeme()
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

    var meme: Meme? {
        didSet {
            memeImageView?.image = meme?.getMeme()
            topTextLabel?.text = meme?.topText
            bottomTextLabel?.text = meme?.bottomText
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}