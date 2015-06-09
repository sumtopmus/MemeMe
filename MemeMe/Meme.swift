//
//  Meme.swift
//  MemeMe
//
//  Created by Oleksandr Iaroshenko on 07.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import Foundation
import UIKit

class Meme {

    var originalImage: UIImage
    var topText: String
    var bottomText: String

    var combinedImage: UIImage

    init(originalImage: UIImage, topText: String, bottomText: String, memeImage: UIImage) {
        self.originalImage = originalImage
        self.topText = topText
        self.bottomText = bottomText
        self.combinedImage = memeImage
    }

    func getMeme() -> UIImage {
        return combinedImage
    }
}