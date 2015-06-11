//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Bernard Nghiem on 6/9/15.
//  Copyright (c) 2015 Bernard Nghiem. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var image:UIImage!
    
    override func viewWillAppear(animated: Bool) {
        imageView.image = self.image
    }
    
}
