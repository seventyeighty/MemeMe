//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Bernard Nghiem on 6/9/15.
//  Copyright (c) 2015 Bernard Nghiem. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
        // Push MemeEditor if meme array is empty
        if memes.count == 0 {
           let mevc = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorController") as! MemeEditorViewController
            self.presentViewController(mevc, animated: false, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    // Loads cell with meme image as well as the meme text as the title
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell", forIndexPath: indexPath) as! UITableViewCell
        let meme = memes[indexPath.item]
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = "\(meme.topString) \(meme.bottomString)"
        return cell
    }
    
    // Pushes to detail view of meme
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dvc = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        dvc.image = memes[indexPath.item].memedImage
        self.navigationController!.pushViewController(dvc, animated: true)
    }
    
}