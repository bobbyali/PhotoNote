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
    
    init() {
        var newPhotoNote = PhotoNote(title: "Boys", photo: UIImage(named: "sample.jpg")!)
        list.append(newPhotoNote)
    }
        
}
