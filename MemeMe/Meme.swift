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

    private var originalImage: UIImage
    private var topText: String
    private var bottomText: String

    private var combinedImage: UIImage

    init(originalImage: UIImage, topText: String, bottomText: String, meme: UIImage) {
        self.originalImage = originalImage
        self.topText = topText
        self.bottomText = bottomText
        self.combinedImage = meme
    }

    func getMeme() -> UIImage {
        return combinedImage
    }
}