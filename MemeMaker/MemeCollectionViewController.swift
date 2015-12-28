//
//  MemeCollectionViewController.swift
//  MemeMaker
//
//  Created by Michael Folcher on 12/22/15.
//  Copyright © 2015 Mike Folcher. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    //MARK: Constants
    let MemeCollectionCellTitle = "MemeCollectionViewCell"
    let MemeDetailViewController = "MemeDetailViewController"
    
    //MARK: Readonly properties
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        //Insert initialization code here
    }
    
    //MARK: UICollectionViewDelegate and UICollectionViewDataSource protocol methods
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.MemeCollectionCellTitle, forIndexPath: indexPath) as! CustomMemeCell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.MemeCollectionCellTitle, forIndexPath: indexPath) 
        let meme = memes[indexPath.item]
        //cell.setText(meme.top, bottomString: meme.bottom)
        let imageView = meme.memeImage
        //cell.backgroundView = imageView
        print(imageView.description)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //Grab the Meme ViewController from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier(self.MemeDetailViewController)
        let memeDetailVC = object as! MemeViewController
        
        //Populate view controller with data from the selected item
        memeDetailVC.meme = self.memes[indexPath.row]
        
        //Present the view controller using navigation
        self.navigationController!.showViewController(memeDetailVC, sender: self)
    }
    
    @IBAction func addPressed(sender: UIBarButtonItem) {
        
        //Grab the Meme ViewController from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier(self.MemeDetailViewController)
        let memeDetailVC = object as! MemeViewController
        
        self.presentViewController(memeDetailVC, animated: true, completion: { self.collectionView!.reloadData() })
        
    }
}
