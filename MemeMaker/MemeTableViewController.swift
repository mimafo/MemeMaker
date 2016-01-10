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
    let MemeDetailViewControllerID = "MemeDetailViewController"
    let MemeEditViewControllerID = "MemeEditViewController"
    let DetailSegue = "tableToDetailSegue"
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    var memesCount: Int = 0
    
    //MARK: ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize the view controller
        self.navigationItem.title = "Sent Memes"
        self.tableView.allowsMultipleSelectionDuringEditing = false
        
        //Set self as the delegate and datasource
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        //Reload data in case items were added, delete, or edited
        self.tableView.reloadData()

    }
    
    override func viewWillDisappear(animated: Bool) {
        self.memesCount = self.memes.count
    }
    
    //MARK: UITableViewDataSource and UITableViewDelegate methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Dequeue a Cell
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell")!
        let meme = self.memes[indexPath.row]
        
        //Set the image text
        cell.textLabel?.text = (meme.topText.characters.count > 0) ? meme.topText : meme.bottomText
        cell.detailTextLabel?.text = meme.topText + " ... " + meme.bottomText
        
        //Set the image, use the original image for better quality and consistent sizing
        cell.imageView?.image = meme.originalImage
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Set the selected meme and segue
        self.selectedIndex = indexPath.row
        self.performSegueWithIdentifier(self.DetailSegue, sender: self)
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            self.appDelegate.memes.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    //MARK: Action Methods
    @IBAction func addPressed(sender: UIBarButtonItem) {
        //Grab the Meme ViewController from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier(self.MemeEditViewControllerID)
        let vc = object as! MemeEditViewController
        
        //Set selectedIndex to the initialValue to indicate that there is no selected meme
        self.selectedIndex = self.initialValue
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
}
