//
//  PhotoNote.swift
//  PhotoNote
//
//  Created by Bobby on 16/04/2015.
//  Copyright (c) 2015 Azuki Apps. All rights reserved.
//

import UIKit

class PhotoNoteCollection {
    
    var list: [PhotoNote] = [PhotoNote]()
    static let sharedInstance = PhotoNoteCollection()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let keyForListOfTitles                 = "listOfTitles"
    let keyForListOfOriginalImagePaths     = "listOfOriginalImagePaths"
    let keyForListOfAnnotatedImagePaths    = "listOfAnnotatedImagePaths"
    
    init() {
        //var newPhotoNote = PhotoNote(title: "Boys", photo: UIImage(named: "sample.jpg")!)
        //list.append(newPhotoNote)
        loadCollection()
    }
    
    func saveCollection() {
        var arrayOfTitles: [NSString] = [NSString]()
        var arrayOfOriginalImagePaths: [NSString]  = [NSString]()
        var arrayOfAnnotatedImagePaths: [NSString] = [NSString]()
        var originalImagePath: String
        var annotatedImagePath: String
        
        for item in self.list {
            arrayOfTitles.append(item.title)
            (originalImagePath, annotatedImagePath) = item.writePhotosToFile()
            arrayOfOriginalImagePaths.append(originalImagePath)
            arrayOfAnnotatedImagePaths.append(annotatedImagePath)
        }
        
        defaults.setObject(arrayOfTitles, forKey: keyForListOfTitles)
        defaults.setObject(arrayOfOriginalImagePaths, forKey: keyForListOfOriginalImagePaths)
        defaults.setObject(arrayOfAnnotatedImagePaths, forKey: keyForListOfAnnotatedImagePaths)
    }
    
    func loadCollection() {
        var readArrayOfTitles: [NSString]? = defaults.objectForKey(keyForListOfTitles) as! [NSString]?
        var readArrayOfOriginalImagePaths: [NSString]? = defaults.objectForKey(keyForListOfOriginalImagePaths) as! [NSString]?
        var readArrayOfAnnotatedImagePaths: [NSString]? = defaults.objectForKey(keyForListOfAnnotatedImagePaths) as! [NSString]?
        
        if let arrayOfTitles = readArrayOfTitles, let arrayOfOriginalImagePaths = readArrayOfOriginalImagePaths, let arrayOfAnnotatedImagePaths = readArrayOfAnnotatedImagePaths {

            if arrayOfTitles.count > 0 {
                for (index, element) in enumerate(arrayOfTitles) {
                    list.append(PhotoNote(title: arrayOfTitles[index] as String, imagePathForOriginalImage: arrayOfOriginalImagePaths[index] as String, imagePathForAnnotatedImage: arrayOfAnnotatedImagePaths[index] as String))
                }
            }
            
        }
    }
    
}
