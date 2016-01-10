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
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: ViewController methods
    override func viewDidLoad() {

        //Display the view title
        self.navigationItem.title = "Meme"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //Display the selected Meme
        if let detailMeme = self.selectedMeme {
            self.imageView.image = detailMeme.memeImage
        }
    }
    
    //MARK: Action methods
    @IBAction func editPressed(sender: UIBarButtonItem) {
        
        //Grab the Edit View Controller from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier(self.MemeEditViewControllerID)
        let vc = object as! MemeEditViewController
        
        //Present the edit view controller
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}
