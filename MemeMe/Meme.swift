//
//  Meme.swift
//  MemeMe
//
//  Created by Bernard Nghiem on 6/9/15.
//  Copyright (c) 2015 Bernard Nghiem. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    var topString: NSString!
    var bottomString: NSString!
    var originalImage: UIImage!
    var memedImage: UIImage!
    
    init(topString: NSString, bottomString: NSString, originalImage: UIImage, memedImage: UIImage) {
        self.topString = topString
        self.bottomString = bottomString
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
}