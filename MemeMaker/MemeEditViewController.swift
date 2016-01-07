//
//  MemeViewController.swift
//  MemeMaker
//
//  Created by Mike Folcher on 12/6/15.
//  Copyright © 2015 Mike Folcher. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    //MARK: UI outlets
    @IBOutlet weak var photoPickButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    
    
    //MARK: Constants
    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    static let kAddMode = 0
    static let kEditMode = 1
    
    //MARK: variables
    var shiftView: Bool = false
    var currentTextField: UITextField? = nil
    var mode = kAddMode
    
    //MARK: ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializeView()
        
        //Set the ViewController as the UITextFieldDelegate for both TextFields
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        //Decorate the TextFields with the proper settings
        self.topTextField.defaultTextAttributes = self.memeTextAttributes
        self.topTextField.textAlignment = .Center
        
        self.bottomTextField.defaultTextAttributes = self.memeTextAttributes
        self.bottomTextField.textAlignment = .Center
        
        if let editMeme = self.selectedMeme {
            self.mode = MemeEditViewController.kEditMode
            self.topTextField.text = editMeme.topText
            self.bottomTextField.text = editMeme.bottomText
            self.imagePickerView.image = editMeme.originalImage
            self.actionButton.enabled = true
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    //MARK: UI Action handlers
    @IBAction func pickButtonPressed(sender: UIBarButtonItem) {
        
        self.forceKeyboardClosed()
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func cameraButtonPressed(sender: UIBarButtonItem) {
        
        self.forceKeyboardClosed()
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    @IBAction func actionButtonPressed(sender: UIBarButtonItem) {
        
        self.forceKeyboardClosed()
        let myMemeImage = self.generateMemedImage()
        
        let avc = UIActivityViewController(activityItems: [myMemeImage], applicationActivities: nil)
        avc.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success {
                self.saveMeme(myMemeImage)
            }
        }
        
        if self.navigationController == nil {
            self.presentViewController(avc, animated: true, completion: nil)
        } else {
            self.navigationController?.presentViewController(avc, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        //Close the keyboard and miss the ViewController
        self.forceKeyboardClosed()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    //MARK: UIImagePickerControllerDelegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //Set the key string appropriately
        var keyString: String!
        if picker.allowsEditing {
            keyString = UIImagePickerControllerEditedImage
        } else {
            keyString = UIImagePickerControllerOriginalImage
        }
        
        if let image = info[keyString] as? UIImage {
            self.imagePickerView.image = image
            self.actionButton.enabled = true
        }

        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: UITextDelegate Methods
    func textFieldDidBeginEditing(textField: UITextField) {
        
        //If the default text is in the textField, clear it out when editing begins
        if textField == self.topTextField && textField.text == self.defaultTopText {
            textField.text = ""
        }
        if textField == self.bottomTextField && textField.text == self.defaultBottomText {
            textField.text = ""
        }
        
        //Set the currentTextField appropriately
        self.currentTextField = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //When return is pressed, dismiss the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        //Unset the currentTextField
        self.currentTextField = nil
        
    }
    
    //MARK: keyboard control methods
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        //Only shift the view if the currentTextField is the bottomTextField
        if let textField = self.currentTextField {
            if textField == self.bottomTextField {
                view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //Only shift the view if the currentTextField is the bottomTextField
        if let textField = self.currentTextField {
            if textField == self.bottomTextField {
                view.frame.origin.y += getKeyboardHeight(notification)
            }
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    //MARK: Helper methods
    func generateMemedImage() -> UIImage {
        
        //Hide toolbars
        self.topToolbar.hidden = true
        self.bottomToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbars
        self.topToolbar.hidden = true
        self.bottomToolbar.hidden = true
        
        return memedImage
    }
    
    func initializeView() {
        
        //Set the default text for the Meme
        self.topTextField.text = self.defaultTopText
        self.bottomTextField.text = self.defaultBottomText
        self.imagePickerView.image = nil
        self.actionButton.enabled = false
        
    }
    
    func saveMeme(memeImage: UIImage) {
        let myMeme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imagePickerView.image!, memeImage: memeImage)
        
        // Add it to the memes array in the Application Delegate
        if self.mode == MemeEditViewController.kAddMode {
            self.appDelegate.memes.append(myMeme)
            self.selectedIndex = self.memes.count - 1
        } else {
            self.appDelegate.memes[self.selectedIndex] = myMeme
        }
        
        //Close the view controller
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func forceKeyboardClosed() {
        if let textField = self.currentTextField {
            textField.resignFirstResponder()
        }
    }



}

