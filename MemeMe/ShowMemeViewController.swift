//
//  ShowMemeViewController.swift
//  MemeMe
//
//  Created by Oleksandr Iaroshenko on 09.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit

class ShowMemeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            setImage()
        }
    }

    @IBAction func onImageTap(sender: UITapGestureRecognizer) {
        let hidden = navigationController!.navigationBar.hidden
        navigationController!.setNavigationBarHidden(!hidden, animated: true)
    }

    var meme: Meme? {
        didSet {
            setImage()
        }
    }

    private func setImage() {
        imageView?.image = meme?.getMeme()
    }

    private func setContentMode() {
        if let image = imageView?.image {
            let fill = (image.size.width > image.size.height) == (imageView.bounds.width > imageView.bounds.height)
            if fill {
                imageView.contentMode = UIViewContentMode.ScaleAspectFill
            } else {
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setContentMode()
    }
}
