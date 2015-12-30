//
//  MemeDetailViewController.swift
//  MemeMaker
//
//  Created by Michael Folcher on 12/30/15.
//  Copyright © 2015 Mike Folcher. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    //MARK: Properties
    var meme: Meme?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        
        if let detailMeme = self.meme {
            self.imageView.image = detailMeme.memeImage
        }
        
    }
    
}
