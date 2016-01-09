//
//  UIImage_Extension.swift
//  MemeMaker
//
//  Created by Michael Folcher on 1/8/16.
//  Copyright © 2016 Mike Folcher. All rights reserved.
//

import UIKit

extension UIImage {
    
    func scaleToSize(size: CGSize) -> UIImage {
        
        //Scaling Algorithm from http://nshipster.com/image-resizing/
        
        let scaleWidth: CGFloat = size.width / self.size.width
        let scaleHeight: CGFloat = size.height / self.size.height
        
        //let scale: CGFloat = (scaleWidth < scaleHeight) ? scaleWidth : scaleHeight;
        
        let size = CGSizeApplyAffineTransform(self.size, CGAffineTransformMakeScale(scaleWidth, scaleHeight))
        let hasAlpha = false
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, 0.0)
        self.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
        
    }
    
}
