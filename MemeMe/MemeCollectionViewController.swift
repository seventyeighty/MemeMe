//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Bernard Nghiem on 6/9/15.
//  Copyright (c) 2015 Bernard Nghiem. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {

    var memes: [Meme] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    // Loads custom meme cell (doesn't use any of it's new properties, just uses standard UITableViewCell properties)
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! CustomMemeCell
        let meme = memes[indexPath.item]
        cell.backgroundView = UIImageView(image: meme.memedImage)
        return cell
    }
    
    // Opens Meme Editor
    @IBAction func OpenMemeEditor(sender: AnyObject) {
        let memeEditorController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorController") as! MemeEditorViewController
        self.presentViewController(memeEditorController, animated: true, completion: nil)
    }
    
    // Push to detail view on select
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let dvc = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        dvc.image = memes[indexPath.item].memedImage
        self.navigationController!.pushViewController(dvc, animated: true)
    }
}
