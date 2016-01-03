//
//  MemeDetailViewController.swift
//  MemeMaker
//
//  Created by Michael Folcher on 12/30/15.
//  Copyright © 2015 Mike Folcher. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    //MARK: Constants
    let MemeEditViewControllerID = "MemeEditViewController"
    
    //MARK: Properties
    var meme: Meme?
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: ViewController methods
    override func viewDidLoad() {
        
        if let detailMeme = self.meme {
            self.imageView.image = detailMeme.memeImage
        }
        
        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editPressed:")
        
    }
    
    func editPressed(sender: UIBarButtonItem) {
        
        //Grab the Meme ViewController from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier(self.MemeEditViewControllerID)
        let vc = object as! MemeEditViewController
        
        //Set the viewcontroller's meme and present the viewcontroller
        vc.meme = self.meme
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}
