//
//  ImageUtil.swift
//  FinalProjectUtahLOL
//
//  Created by Nite Out on 4/8/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//
import UIKit

class ImageUtil: NSObject {
    
    class func imageWithName(name: String, size: CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        UIImage(named: name)?.drawInRect(CGRectMake(0, 0, size.width, size.height))
        var imgSnapShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return imgSnapShot.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    }
}
