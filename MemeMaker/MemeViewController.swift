//
//  MemeViewController.swift
//  MemeMaker
//
//  Created by Mike Folcher on 12/6/15.
//  Copyright © 2015 Mike Folcher. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    //MARK: UI outlets
    @IBOutlet weak var photoPickButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    
    //MARK: Constants
    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 3.0
    ]
    
    //MARK: variables
    var meme: Meme?
    var shiftView: Bool = false
    
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
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func cameraButtonPressed(sender: UIBarButtonItem) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    @IBAction func actionButtonPressed(sender: UIBarButtonItem) {
        let myMemeImage = self.generateMemedImage()
        
        let avc = UIActivityViewController(activityItems: [myMemeImage], applicationActivities: nil)
        
        self.navigationController?.presentViewController(avc, animated: true, completion: nil)
        
    }

    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        //reset the view
        self.initializeView()
    }
    

    //MARK: UIImagePickerControllerDelegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //TODO: This code needs to change
        for object in info.values {
            if let image = object as? UIImage {
                self.imagePickerView.image = image
                self.actionButton.enabled = true
                break
            }
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
        if textField == self.bottomTextField {
            //Only set shiftView to true if the bottomTextField is in focus
            self.shiftView = true
            if textField.text == self.defaultBottomText {
                textField.text = ""
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //When return is pressed, dismiss the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.shiftView = false
        
        //If the text is in the textField is empty, add back the default text
        if textField == self.topTextField && textField.text!.isEmpty {
            textField.text = self.defaultTopText
        }
        if textField == self.bottomTextField && textField.text!.isEmpty {
            textField.text = self.defaultBottomText
        }
        
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
        if self.shiftView {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.shiftView {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    //MARK: Helper methods
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        self.toolbar.hidden = true
        self.navigationController?.navigationBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        self.toolbar.hidden = false
        self.navigationController?.navigationBar.hidden = false
        
        return memedImage
    }
    
    func initializeView() {
        
        //Set the default text for the Meme
        self.topTextField.text = self.defaultTopText
        self.bottomTextField.text = self.defaultBottomText
        self.imagePickerView.image = nil
        self.actionButton.enabled = false
    
    }



}

