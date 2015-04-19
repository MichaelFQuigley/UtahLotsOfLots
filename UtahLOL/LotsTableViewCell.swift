//
//  LotsTableViewCell.swift
//  FinalProjectUtahLOL
//
//  Created by Nite Out on 4/14/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit

class LotsTableViewCell: UITableViewCell {
    
    var nameLabel: UILabel?
    var addressLabel: UILabel?
    var statusLabel: UILabel?
    
    override init(){
        super.init()
        nameLabel    = UILabel()
        addressLabel = UILabel()
        statusLabel  = UILabel()
        
        addSubview(nameLabel!)
        addSubview(addressLabel!)
        addSubview(statusLabel!)
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        nameLabel    = UILabel()
        addressLabel = UILabel()
        statusLabel  = UILabel()
        
        addSubview(nameLabel!)
        addSubview(addressLabel!)
        addSubview(statusLabel!)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        self.layer.borderWidth   = 3.0
        self.layer.borderColor   = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).CGColor
        self.layer.cornerRadius  = 8.0
        self.layer.masksToBounds = true
        
      //  var gradient: CAGradientLayer = CAGradientLayer.layer()
        
        var cursor: CGPoint = CGPointZero
        
        nameLabel?.frame         = CGRectMake(cursor.x, cursor.y, frame.width, frame.height / 3.0)
        nameLabel?.textAlignment = .Center
        nameLabel?.font          = UIFont(name: AppUtil.themeFont, size: 24.0)
        cursor.y += nameLabel!.frame.height
        
        addressLabel?.frame         = CGRectMake(cursor.x, cursor.y, frame.width, 2.0 * frame.height / 3.0)
        addressLabel?.textAlignment = .Center
        addressLabel?.font          = UIFont(name: AppUtil.themeFont, size: 24.0)
        cursor.x += addressLabel!.frame.width
        
        statusLabel?.frame         = CGRectMake(cursor.x, cursor.y, frame.width, 2.0 * frame.height / 3.0)
        statusLabel?.textAlignment = .Center
        statusLabel?.font          = UIFont(name: AppUtil.themeFont, size: 24.0)
        
    }
    
    override func drawRect(rect: CGRect) {
        let context: CGContextRef = UIGraphicsGetCurrentContext()

        let locs: [CGFloat] = [0.0, 1.0]
        let firstColor: [CGFloat] = [0.9, 0.9, 0.9, 1.0]
        let secondColor: [CGFloat] = [0.7, 0.7, 0.7, 1.0]

        var firstGradient: CGGradientRef = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(),
            firstColor + secondColor,
            locs,
            size_t((firstColor.count + secondColor.count) / 4))
        
        var secondGradient: CGGradientRef = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(),
            secondColor + firstColor,
            locs,
            size_t((firstColor.count + secondColor.count) / 4))
        
        var topPoint: CGPoint = CGPointMake(self.bounds.midX, 0.0)
        var midPoint: CGPoint = CGPointMake(self.bounds.midX, self.bounds.midY)
        var bottomPoint: CGPoint = CGPointMake(self.bounds.midX, self.bounds.height + self.bounds.origin.y)
        CGContextDrawLinearGradient(context, firstGradient, topPoint, midPoint, 0)
        CGContextDrawLinearGradient(context, secondGradient, midPoint, bottomPoint, 0)
    }
}
