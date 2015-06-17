//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Bernard Nghiem on 6/9/15.
//  Copyright (c) 2015 Bernard Nghiem. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var editToolBar: UIToolbar!
    @IBOutlet weak var editNavBar: UINavigationBar!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var imageToEdit: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    // Declaration of checks and properties
    var didBeginEditTop: Bool!
    var didBeginEditBottom: Bool!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3
    ]
    
    // Let's setup all attributes and assign text delegates here
    func setup() {
        shareButton.enabled = false
        
        topText.delegate = self
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = NSTextAlignment.Center
        
        bottomText.delegate = self
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = NSTextAlignment.Center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // Subscribe and observe keyboard action
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    // Handle view on keyboard action
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    // Dismiss keyboard on "return" press
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    // Following functions handle image selection
    @IBAction func selectImageFromAlbum(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        shareButton.enabled = true
        imageToEdit.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Create memed Image
    func generateMemedImage() -> UIImage
    {
        editToolBar.hidden = true
        editNavBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        editToolBar.hidden = false
        editNavBar.hidden = false
        
        return memedImage
    }
    
    func save() {
        var meme = Meme(topString: topText.text, bottomString: bottomText.text, originalImage: imageToEdit.image!, memedImage: generateMemedImage())
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    // Share Image and present the Tab Controller
    @IBAction func ShareMemeImage(sender: AnyObject) {
        let meme = Meme(topString: topText.text, bottomString: bottomText.text, originalImage: imageToEdit.image!, memedImage: generateMemedImage())
        
        let avc = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        
        avc.completionWithItemsHandler = {
            (activity, success, items, error) in
            
            if (success == true) {
                self.save()
                avc.dismissViewControllerAnimated(true, completion: nil)
                let nextController = self.storyboard?.instantiateViewControllerWithIdentifier("TabController") as! UITabBarController
                self.presentViewController(nextController, animated: true, completion: nil)
            }
        }
        self.presentViewController(avc, animated: true, completion: nil)
    }

}
