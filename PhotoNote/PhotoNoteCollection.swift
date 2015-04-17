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
    
    init() {
        //var newPhotoNote = PhotoNote(title: "Boys", photo: UIImage(named: "sample.jpg")!)
        //list.append(newPhotoNote)
        loadCollection()
    }
    
    func saveCollection() {
        var arrayOfTitles: [NSString] = [NSString]()
        for item in self.list {
            arrayOfTitles.append(item.title)
        }
        defaults.setObject(arrayOfTitles, forKey: keyForListOfTitles)
    }
    
    func loadCollection() {
        var readArrayOfTitles: [NSString]? = defaults.objectForKey(keyForListOfTitles) as! [NSString]?
        
        if let arrayOfTitles = readArrayOfTitles {
            if arrayOfTitles.count > 0 {
                for (index, element) in enumerate(arrayOfTitles) {
                    list.append(PhotoNote(title: arrayOfTitles[index] as String))
                }
            }            
        }
    }
    
}
