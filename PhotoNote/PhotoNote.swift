//
//  PhotoNote.swift
//  PhotoNote
//
//  Created by Bobby on 16/04/2015.
//  Copyright (c) 2015 Azuki Apps. All rights reserved.
//

import UIKit

class PhotoNote {
    
    var title: String
    var date = NSDate()
    let dateFormatter = NSDateFormatter()
    var photoAnnotated: UIImage
    var photoOriginal: UIImage
    
    init(title:String, photo:UIImage) {
        self.title = title
        self.photoAnnotated = photo
        self.photoOriginal = photo
        self.date = NSDate()        
    }
    
    
}
