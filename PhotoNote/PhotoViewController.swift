//
//  PhotoViewController.swift
//  PhotoNote
//
//  Created by Bobby on 16/04/2015.
//  Copyright (c) 2015 Azuki Apps. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    var imageView: UIImageView!
    var photonote: PhotoNote!
    
    var swiped: Bool = false
    var lastPoint = CGPoint.zeroPoint
    
    let pinchRecognizer = UIPinchGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let newButton = UIBarButtonItem(title: "Reset", style: UIBarButtonItemStyle.Plain, target: self, action: "resetPhoto:")
        self.navigationItem.rightBarButtonItem = newButton
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        self.imageView.image = resizeImageWithAspectFit(self.photonote.photoAnnotated, size: view.frame.size)
        
        
        
        //self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        //self.imageView.clipsToBounds = true
        
        //self.imageView.bounds = CGRectMake(0.0, 0.0, self.photonote.photoAnnotated.size.width, self.photonote.photoAnnotated.size.height)
        //self.imageView.center = self.view.center
        //self.imageView.userInteractionEnabled = true
        //self.pinchRecognizer.delegate = self
        //self.imageView.addGestureRecognizer(self.pinchRecognizer)
        
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
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        // 6
        swiped = true
        //var numTouches = touches.count
        //println("Number of touches is \(numTouches)")
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
        self.photonote.writeAnnotatedPhotoToFile()
    }
    
    func resetPhoto(sender:UIButton!) {
        if let imageView = self.imageView {
            imageView.image = self.photonote.photoOriginal
            self.photonote.photoAnnotated = self.photonote.photoOriginal
            self.photonote.writeAnnotatedPhotoToFile()
        }
    }
    
    /*
    func pinchGestureDetected(sender: UIPinchGestureRecognizer) {
        let touchPosition = sender.locationInView(self.imageView)
        println("pinching")
        if sender.state == UIGestureRecognizerState.Began {
            var scale: CGFloat = sender.scale
            let myTransform:CGAffineTransform = CGAffineTransformMakeScale(scale, scale)
            self.imageView!.transform = myTransform
        }
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    */

    // from https://gist.github.com/jberlana/d6219b92d62c58bed479
    func resizeImageWithAspectFit(image:UIImage, size:CGSize) -> UIImage {
        let aspectFitSize = self.getAspectFitRect(origin: image.size, destination: size)
        let resizedImage = self.resizeImage(image, size: aspectFitSize)
        return resizedImage
    }
    
    func getAspectFitRect(origin src:CGSize, destination dst:CGSize) -> CGSize {
        var result = CGSizeZero
        var scaleRatio = CGPoint()
        
        if (dst.width != 0) {scaleRatio.x = src.width / dst.width}
        if (dst.height != 0) {scaleRatio.y = src.height / dst.height}
        let scaleFactor = max(scaleRatio.x, scaleRatio.y)
        
        result.width  = scaleRatio.x * dst.width / scaleFactor
        result.height = scaleRatio.y * dst.height / scaleFactor
        return result
    }
    
    func resizeImage(image:UIImage, size:CGSize) -> UIImage {
        let scale     = UIScreen.mainScreen().scale
        let size      = scale > 1 ? CGSizeMake(size.width/scale, size.height/scale) : size
        let imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale);
        image.drawInRect(imageRect)
        let scaled = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaled;
    }

}
