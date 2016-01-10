//
//  UIViewController_Extension.swift
//  MemeMaker
//
//  Created by Michael Folcher on 1/5/16.
//  Copyright © 2016 Mike Folcher. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: Readonly properties
    var appDelegate: AppDelegate {
        return (UIApplication.sharedApplication().delegate as! AppDelegate)
    }
    var memes: [Meme] {
        return self.appDelegate.memes
    }
    
    var initialValue: Int {
        return -1
    }
    
    var selectedMeme: Meme? {
        if self.selectedIndex > self.initialValue && self.selectedIndex < self.memes.count {
            return self.memes[self.selectedIndex]
        }
        return nil
    }
    
    //MARK: Read/write properties
    var selectedIndex: Int {
        get {
            return self.appDelegate.selectedIndex
        }
        set(value) {
            self.appDelegate.selectedIndex = value
        }
    }
    
    

    
}
