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
    
    //MARK: ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Insert initialization code here
        self.navigationItem.title = "Sent Memes"
        
        self.configureFlowLayout()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Reload data in case items were added, delete, or edited
        self.collectionView?.reloadData()
        
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
        
        //Set the selected index and segue
        self.selectedIndex = indexPath.row
        self.performSegueWithIdentifier(self.DetailSegue, sender: self)

        
    }
    
    //MARK: UI Action methods
    @IBAction func addPressed(sender: UIBarButtonItem) {
        
        //Grab the Meme ViewController from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier(self.MemeEditViewControllerID)
        let vc = object as! MemeEditViewController
        
        //Set selectedIndex to the initialValue to indicate that there is no selected meme
        self.selectedIndex = self.initialValue
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    //MARK: Private methods
    func configureFlowLayout() {
        
        //Define the flow layout
        let space: CGFloat = 1.0
        let itemsFactor: CGFloat = 3.5
        
        let dimension = (self.view.frame.width - (2 * space)) / itemsFactor
        self.flowLayout.minimumInteritemSpacing = space
        self.flowLayout.minimumLineSpacing = space
        self.flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
    }
}
