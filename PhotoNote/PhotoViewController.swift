//
//  PhotoViewController.swift
//  PhotoNote
//
//  Created by Bobby on 16/04/2015.
//  Copyright (c) 2015 Azuki Apps. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    var imageView: UIImageView?
    var photonote: PhotoNote!
    
    var swiped: Bool = false
    var lastPoint = CGPoint.zeroPoint
    
    let scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.view = self.scrollView
        
        
        let newButton = UIBarButtonItem(title: "Reset", style: UIBarButtonItemStyle.Plain, target: self, action: "resetPhoto:")
        self.navigationItem.rightBarButtonItem = newButton
        
        var frame = self.view.frame
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.imageView?.image = self.photonote.photoAnnotated
        self.view.addSubview(self.imageView!)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        swiped = false
        if let touch = touches.first as? UITouch {
            lastPoint = touch.locationInView(self.view)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        self.imageView!.image!.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineWidth(context, CGFloat(10.0))
        CGContextSetRGBStrokeColor(context, CGFloat(1.0), CGFloat(0.0), CGFloat(0.0), 1.0)
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        // 4
        CGContextStrokePath(context)
        
        // 5
        self.imageView!.image = UIGraphicsGetImageFromCurrentImageContext()
        //self.photonote?.photo.alpha = CGFloat(1.0)
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        // 6
        swiped = true
        if let touch = touches.first as? UITouch {
            let currentPoint = touch.locationInView(view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(self.imageView!.frame.size)
        self.imageView!.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: 1.0)
        self.imageView!.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: CGFloat(1.0))
        self.imageView!.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.photonote.photoAnnotated = self.imageView!.image!
    }
    
    func resetPhoto(sender:UIButton!) {
        if let imageView = self.imageView {
            imageView.image = self.photonote.photoOriginal
            self.photonote.photoAnnotated = self.photonote.photoOriginal
        }
    }

}