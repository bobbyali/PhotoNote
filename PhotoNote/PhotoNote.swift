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
        writePhotosToFile()
    }
    
    init(title:String) {
        self.title = title
        self.date = NSDate()
        readPhotosFromFile()
    }
    
    func writePhotosToFile() {
        
        var filePathForOriginal, filePathForAnnotated: String
        (filePathForOriginal, filePathForAnnotated) = getImageFilePaths()
        
        var imageOriginalData:  NSData = UIImageJPEGRepresentation(self.photoOriginal, 1.0)
        var imageAnnotatedData: NSData = UIImageJPEGRepresentation(self.photoAnnotated, 1.0)
        
        fileManager.createFileAtPath(filePathForOriginal, contents: imageOriginalData, attributes: nil)
        fileManager.createFileAtPath(filePathForAnnotated, contents: imageAnnotatedData, attributes: nil)
        
        println("Images saved")
        
    }
    
    func readPhotosFromFile() {
        
        var imagePathForOriginal, imagePathForAnnotated: String
        (imagePathForOriginal, imagePathForAnnotated) = getImageFilePaths()
        
        if (fileManager.fileExistsAtPath(imagePathForOriginal)) {
            println("Files available");
            self.photoOriginal  = UIImage(contentsOfFile: imagePathForOriginal)!
            self.photoAnnotated = UIImage(contentsOfFile: imagePathForAnnotated)!
        }
        else {
            println("Files not available");
        }
    }
    
    
    func writeAnnotatedPhotoToFile() {
        var filePathForOriginal, filePathForAnnotated: String
        (filePathForOriginal, filePathForAnnotated) = getImageFilePaths()
        var imageAnnotatedData: NSData = UIImagePNGRepresentation(self.photoAnnotated)
        fileManager.createFileAtPath(filePathForAnnotated, contents: imageAnnotatedData, attributes: nil)
        println("Annotated image saved")
    }
    
    func getImageFilePaths() -> (imagePathForOriginal:String, imagePathForAnnotated:String) {
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        var titleOriginal = self.title.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var titleAnnotated = titleOriginal + "_annotated"
        
        var filePathForOriginal  = "\(paths)/\(titleOriginal).png"
        var filePathForAnnotated = "\(paths)/\(titleAnnotated).png"
        
        return (filePathForOriginal, filePathForAnnotated)
    }
    
}
