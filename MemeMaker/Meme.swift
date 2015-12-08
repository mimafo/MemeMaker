//
//  Meme.swift
//  MemeExperiment
//
//  Created by Michael Folcher on 12/5/15.
//  Copyright © 2015 Mimafo. All rights reserved.
//

import Foundation
import UIKit

class Meme : NSObject {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memeImage: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memeImage: UIImage) {
        
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memeImage = memeImage
        
    }
    
    
}
