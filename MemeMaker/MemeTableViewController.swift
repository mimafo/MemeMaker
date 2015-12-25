//
//  MemeTableViewController.swift
//  MemeMaker
//
//  Created by Michael Folcher on 12/22/15.
//  Copyright © 2015 Mike Folcher. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: Constants
    let MemeTableCellTitle = "MemeTableCell"
    let MemeDetailViewController = "MemeDetailViewController"
    
    //MARK: Readonly properties
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        //Initialize the view controller
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    //MARK: UITableViewDataSource and UITableViewDelegate methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Dequeue a Cell
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell")!
        let meme = self.memes[indexPath.row]
        
        //Set the topText and image
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.originalImage
        
        //If the cell has a detail label, set it to the bottomText
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = meme.bottomText
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Grab the Meme ViewController from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier(self.MemeDetailViewController)
        let memeDetailVC = object as! MemeViewController
        
        //Populate view controller with data from the selected item
        memeDetailVC.meme = self.memes[indexPath.row]
        
        //Present the view controller using navigation
        self.navigationController!.showViewController(memeDetailVC, sender: self)
        
    }
    
    //MARK: Action Methods
    @IBAction func addPressed(sender: UIBarButtonItem) {
        //Grab the Meme ViewController from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier(self.MemeDetailViewController)
        let memeDetailVC = object as! MemeViewController
        
        self.presentViewController(memeDetailVC, animated: true, completion: nil)
    }
}
