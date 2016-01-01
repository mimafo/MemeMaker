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
    
    //MARK: Properties
    var selectedMeme: Meme?
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize the view controller

        self.navigationItem.title = "Sent Memes"
        
        //Set self as the delegate and datasource
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        //This is temporary
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.DetailSegue {
            let vc = segue.destinationViewController as! MemeDetailViewController
            vc.meme = self.selectedMeme
        }
    }
    
    //MARK: UITableViewDataSource and UITableViewDelegate methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Dequeue a Cell
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell")!
        let meme = self.memes[indexPath.row]
        
        //Set the topText and image
        cell.textLabel?.text = (meme.topText.characters.count > 0) ? meme.topText : meme.bottomText;
        cell.imageView?.contentMode = .ScaleToFill
        cell.imageView?.image = meme.memeImage
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Set the selected meme and segue
        self.selectedMeme = self.memes[indexPath.row]
        self.performSegueWithIdentifier(self.DetailSegue, sender: self)
        
    }
    
    //MARK: Action Methods
    @IBAction func addPressed(sender: UIBarButtonItem) {
        //Grab the Meme ViewController from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier(self.MemeEditViewControllerID)
        let vc = object as! MemeEditViewController
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
}
