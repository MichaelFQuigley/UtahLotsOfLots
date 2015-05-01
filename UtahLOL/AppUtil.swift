//
//  AppUtil.swift
//  UtahLOL
//
//  Created by Nite Out on 4/14/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit

class AppUtil: NSObject {
    class var themeFont: String{
        return "Cochin"
    }
    
    class var themeColor: UIColor
    {
        return UIColor(red: 250.0/255.0, green: 241.0/255.0, blue: 150.0/255.0, alpha: 1.0)
    }
    
    class func getThemeTitleLabelWithWidth(width: CGFloat) -> UILabel
    {
        var titleLabel: UILabel = UILabel(frame: CGRectMake(0, 0, width, 44.0))
        titleLabel.font = UIFont(name: AppUtil.themeFont, size: 24.0)
        titleLabel.textAlignment = NSTextAlignment.Center
        
        return titleLabel
    }
}
