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
    let MemeDetailViewControllerID = "MemeDetailViewController"
    let MemeEditViewControllerID = "MemeEditViewController"
    let DetailSegue = "collectionToDetailSegue"
    
    //MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //MARK: Properties
    var selectedMeme: Meme?
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    //MARK: ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Insert initialization code here
        self.navigationItem.title = "Sent Memes"
        self.selectedMeme = nil
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Configure the flow layout based on the current orientation
        self.configureFlowLayout()
        
        //This is temporary
        self.collectionView?.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.DetailSegue {
            let vc = segue.destinationViewController as! MemeDetailViewController
            vc.meme = self.selectedMeme
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        //Call configureFlowLayout whenever the orientation changes
        self.configureFlowLayout()
    }
    
    //MARK: UICollectionViewDelegate and UICollectionViewDataSource protocol methods
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.MemeCollectionCellTitle, forIndexPath: indexPath) as! MemeCollectionViewCell
        
        //Get the current image and display it
        let meme = memes[indexPath.item]
        cell.imageView.image = meme.memeImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //Set the selected meme and segue
        self.selectedMeme = self.memes[indexPath.row]
        self.performSegueWithIdentifier(self.DetailSegue, sender: self)

        
    }
    
    //MARK: UI Action methods
    @IBAction func addPressed(sender: UIBarButtonItem) {
        
        //Grab the Meme ViewController from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier(self.MemeEditViewControllerID)
        let vc = object as! MemeEditViewController
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    //MARK: Private methods
    func configureFlowLayout() {
        
        //Define the flow layout
        let space: CGFloat = 1.0
        var itemsPerRow: CGFloat = 3.5
        if UIApplication.sharedApplication().statusBarOrientation == .LandscapeLeft ||
            UIApplication.sharedApplication().statusBarOrientation == .LandscapeRight {
                itemsPerRow = 5.5
        }
        let dimension = (self.view.frame.width - (2 * space)) / itemsPerRow
        self.flowLayout.minimumInteritemSpacing = space
        self.flowLayout.minimumLineSpacing = space
        self.flowLayout.itemSize = CGSizeMake(dimension, dimension)
        print("Dimension: \(dimension)")
        
    }
}
