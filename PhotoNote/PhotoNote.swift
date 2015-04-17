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
    var photoAnnotated: UIImage!
    var photoOriginal: UIImage!
    let fileManager = NSFileManager.defaultManager()
    
    init(title:String, photo:UIImage) {
        self.title = title
        self.photoAnnotated = photo
        self.photoOriginal = photo
        self.date = NSDate()
    }
    
    init(title:String, imagePathForOriginalImage:String, imagePathForAnnotatedImage:String) {
        self.title = title
        self.date = NSDate()
        readPhotosFromFile(imagePathForOriginalImage, imagePathForAnnotated: imagePathForAnnotatedImage)
    }
    
    func writePhotosToFile() -> (String, String) {
        
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        var titleOriginal = self.title.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var titleAnnotated = titleOriginal + "_annotated"
        
        var filePathForOriginal  = "\(paths)/\(titleOriginal).png"
        var filePathForAnnotated = "\(paths)/\(titleAnnotated).png"
        
        var imageOriginalData:  NSData = UIImagePNGRepresentation(self.photoOriginal)
        var imageAnnotatedData: NSData = UIImagePNGRepresentation(self.photoAnnotated)
        
        fileManager.createFileAtPath(filePathForOriginal, contents: imageOriginalData, attributes: nil)
        fileManager.createFileAtPath(filePathForAnnotated, contents: imageAnnotatedData, attributes: nil)
        
        println("Images saved")
        
        return (filePathForOriginal, filePathForAnnotated)
        
    }
    
    func readPhotosFromFile(imagePathForOriginal: String, imagePathForAnnotated: String) {
        
        if (fileManager.fileExistsAtPath(imagePathForOriginal))
        {
            println("Files available");
            self.photoOriginal  = UIImage(contentsOfFile: imagePathForOriginal)!
            self.photoAnnotated = UIImage(contentsOfFile: imagePathForAnnotated)!
            //let data: NSData = UIImagePNGRepresentation(imageis)
        }
        else
        {
            println("Files not available");
        }
        
    }
    
    
    func writeAnnotatedPhotoToFile() {
        
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var titleAnnotated = self.title.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil) + "_annotated"
        var filePathForAnnotated = "\(paths)/\(titleAnnotated).png"
        var imageAnnotatedData: NSData = UIImagePNGRepresentation(self.photoAnnotated)
        fileManager.createFileAtPath(filePathForAnnotated, contents: imageAnnotatedData, attributes: nil)
        println("Annotated image saved")
        
    }
    
}
