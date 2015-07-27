//
//  ImageEditViewController.swift
//  MemeMe
//
//  Created by Oleksandr Iaroshenko on 06.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import UIKit
import CoreData

// TODO: Check why the font is transparent (NSForegroundColorAttributeName does not change the appearance)
// TODO: If keyboard is dismissed with CMD+K and bottomTextField started editing, press CMD+K again. The meme view will fly away upwards.
// TODO: Add custom crop/scale for both(?) original and combined images
// TODO: Add icons for table/collection views

class ImageEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: - Magic values

    private struct Defaults {
        static let MemeFontName = "HelveticaNeue-CondensedBlack"
        static let MemeFontSize: CGFloat = 40

        static let MemeTextStrokeColor = UIColor.whiteColor()
        static let MemeTextForegroundColor = UIColor.blackColor()
        static let MemeTextBackgroundColor = UIColor.clearColor()
        static let MemeTextFont = UIFont(name: MemeFontName, size: MemeFontSize)!
        static let MemeTextStrokeWidth = 4.0

        static let MemeTextTop = "TOP"
        static let MemeTextBottom = "BOTTOM"

        static let TextVerticalOffsetInEditor: CGFloat = 50
        static let TextVerticalOffsetFinal: CGFloat = 20

        static let ToolbarTransparency: CGFloat = 0.95

        static let MemesDirectory = "memes"
        static let DateFormat = "ddMMyyyy-HHmmss"
        static let ImageExtension = ".png"

        static let KeyboardWillShowSelector: Selector = "keyboardWillShow:"
        static let KeyboardWillHideSelector: Selector = "keyboardWillHide:"

        static let TabBarViewControllerID = "Tab Bar View Controller"
    }

    // MARK: - Actions and Outlets

    @IBOutlet weak var memeView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!

    @IBAction func pickPhotoFromCamera(sender: UIBarButtonItem) {
        pickPhotoFrom(UIImagePickerControllerSourceType.Camera)

    }

    @IBAction func pickPhotoFromLibrary(sender: UIBarButtonItem) {
        pickPhotoFrom(UIImagePickerControllerSourceType.PhotoLibrary)
    }

    func pickPhotoFrom(source: UIImagePickerControllerSourceType) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = source
        imagePickerVC.delegate = self
        presentViewController(imagePickerVC, animated: true, completion: nil)
    }

    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let memeImage = createMemeImage()

        let activityVC = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) in
            if completed {
                self.saveMeme(memeImage)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        presentViewController(activityVC, animated: true, completion: nil)
    }

    @IBAction func onImageTap(sender: UITapGestureRecognizer) {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
    }

    // MARK: - Layout

    var textOffsetConstraints = [NSLayoutConstraint]()

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    private func setTextOffset(offset: CGFloat) {
        removeTextOffsetConstraints()

        let topSpaceConstraint = NSLayoutConstraint(item: topTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: memeView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: offset)
        let bottomSpaceConstraint = NSLayoutConstraint(item: memeView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: bottomTextField, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: offset)

        textOffsetConstraints = [topSpaceConstraint, bottomSpaceConstraint]

        memeView.addConstraint(topSpaceConstraint)
        memeView.addConstraint(bottomSpaceConstraint)
    }

    private func removeTextOffsetConstraints() {
        memeView.removeConstraints(textOffsetConstraints)
    }

    // MARK: - Text Edit

    var topTextEdited = false
    var bottomTextEdited = false

    var bottomTextIsBeingEdited = false

    private func initTextField(textField: UITextField, withText text: String) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : Defaults.MemeTextStrokeColor,
            NSForegroundColorAttributeName : Defaults.MemeTextForegroundColor,
            NSBackgroundColorAttributeName : Defaults.MemeTextBackgroundColor,
            NSFontAttributeName : Defaults.MemeTextFont,
            NSStrokeWidthAttributeName : Defaults.MemeTextStrokeWidth
        ]

        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
        textField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        textField.text = text
        textField.delegate = self
    }

    private func hideTextFields(hidden: Bool) {
        topTextField.hidden = hidden
        bottomTextField.hidden = hidden
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField {
        case topTextField:
            if !topTextEdited {
                topTextField.text = ""
                topTextEdited = true
            }
        case bottomTextField:
            if !bottomTextEdited {
                bottomTextField.text = ""
                bottomTextEdited = true
            }
            bottomTextIsBeingEdited = true
        default:
            break
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    func keyboardWillShow(notification: NSNotification) {
        if bottomTextIsBeingEdited {
            self.view.frame.origin.y -= getKeyboardHeight(notification) - bottomToolbar.frame.height
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if bottomTextIsBeingEdited {
            self.view.frame.origin.y += getKeyboardHeight(notification) - bottomToolbar.frame.height
            bottomTextIsBeingEdited = false
        }
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        return keyboardSize?.CGRectValue().height ?? 0
    }

    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Defaults.KeyboardWillShowSelector, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Defaults.KeyboardWillHideSelector, name: UIKeyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    // MARK: - Meme Generating Engine

    private func createMemeImage() -> UIImage {
        setTextOffset(Defaults.TextVerticalOffsetFinal)

        UIGraphicsBeginImageContext(memeView.frame.size)

        memeView.drawViewHierarchyInRect(memeView.bounds, afterScreenUpdates: true)
        let meme = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        setTextOffset(Defaults.TextVerticalOffsetInEditor)

        return meme
    }

    private func saveMeme(memeImage: UIImage) {
        if let context = CoreDataManager.sharedInstance.context {
            let path = saveMemeToFile(memeImage)

            let meme = Meme(context: context, pathToEditedImage: path, topText: topTextField.text, bottomText: bottomTextField.text)

            CoreDataManager.sharedInstance.saveContext()
        }
    }

    private func saveMemeToFile(memeImage: UIImage) -> String {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as! String
        let memesDirectory = documentsDirectory.stringByAppendingPathComponent(Defaults.MemesDirectory)
        let fileName = getFileNameForNewMeme()

        let absoluteFilePath = memesDirectory.stringByAppendingPathComponent(fileName)
        let relativeFilePath = Defaults.MemesDirectory.stringByAppendingPathComponent(fileName)

        if !NSFileManager.defaultManager().fileExistsAtPath(memesDirectory) {
            NSFileManager.defaultManager().createDirectoryAtPath(memesDirectory, withIntermediateDirectories: false, attributes: nil, error: NSErrorPointer())
        }

        UIImagePNGRepresentation(memeImage).writeToFile(absoluteFilePath, atomically: true)

        return relativeFilePath
    }

    private func getFileNameForNewMeme() -> String {
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = Defaults.DateFormat
        let fileName = formatter.stringFromDate(currentDateTime) + Defaults.ImageExtension

        return fileName
    }

    // MARK: - UIImagePickerControllerDelegate methods

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            let fill = (image.size.width > image.size.height) == (memeView.bounds.width > memeView.bounds.height)
            if fill {
                imageView.contentMode = UIViewContentMode.ScaleAspectFill
            } else {
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
            }

            hideTextFields(false)
            shareButton.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)

        initTextField(topTextField, withText: Defaults.MemeTextTop)
        initTextField(bottomTextField, withText: Defaults.MemeTextBottom)

        setTextOffset(Defaults.TextVerticalOffsetInEditor)

        hideTextFields(true)

        topToolbar.alpha = Defaults.ToolbarTransparency
        bottomToolbar.alpha = Defaults.ToolbarTransparency

        shareButton.enabled = false

        imageView.contentMode = UIViewContentMode.ScaleAspectFill
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        unsubscribeFromKeyboardNotifications()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let image = imageView.image {
            let fill = (image.size.width > image.size.height) == (memeView.bounds.width > memeView.bounds.height)
            if fill {
                imageView.contentMode = UIViewContentMode.ScaleAspectFill
            } else {
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
            }
        }
    }
}