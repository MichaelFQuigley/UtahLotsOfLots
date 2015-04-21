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
    private var _gradientColor: [CGFloat] = [0.9, 0.9, 0.9, 1.0]
    
    override init(){
        super.init()
        nameLabel    = UILabel()
        addressLabel = UILabel()
        statusLabel  = UILabel()
        
        gradientColor = UIColor.grayColor()
        
        addSubview(nameLabel!)
        addSubview(addressLabel!)
        addSubview(statusLabel!)
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, gradientColor: UIColor) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        nameLabel    = UILabel()
        addressLabel = UILabel()
        statusLabel  = UILabel()
        
        self.gradientColor = gradientColor
        
        addSubview(nameLabel!)
        addSubview(addressLabel!)
        addSubview(statusLabel!)
    }
    
    
    
    var gradientColor: UIColor
    {
        get{ return UIColor(red: _gradientColor[0], green: _gradientColor[1], blue: _gradientColor[1], alpha: 1.0)}
        set{
            var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
            
            newValue.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            _gradientColor = [red, green, blue, 1.0]
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        self.layer.borderWidth   = 3.0
        self.layer.borderColor   = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).CGColor
        self.layer.cornerRadius  = 8.0
        self.layer.masksToBounds = true

        var cursor: CGPoint = CGPointZero
        
        var labelColor: UIColor = UIColor.whiteColor()
        
        nameLabel?.frame         = CGRectMake(cursor.x, cursor.y, frame.width, frame.height / 3.0)
        nameLabel?.textAlignment = .Center
        nameLabel?.font          = UIFont(name: AppUtil.themeFont, size: 24.0)
        nameLabel?.textColor     = labelColor
        cursor.y += nameLabel!.frame.height
    
        statusLabel?.frame         = CGRectMake(cursor.x, cursor.y, frame.width, frame.height / 3.0)
        statusLabel?.textAlignment = .Center
        statusLabel?.font          = UIFont(name: AppUtil.themeFont, size: 24.0)
        statusLabel?.textColor     = labelColor
        cursor.y += statusLabel!.frame.height
        
        addressLabel?.frame         = CGRectMake(cursor.x, cursor.y, frame.width, frame.height / 3.0)
        addressLabel?.textAlignment = .Center
        addressLabel?.font          = UIFont(name: AppUtil.themeFont, size: 24.0)
        addressLabel?.textColor     = labelColor
        cursor.y += addressLabel!.frame.height
    }
    
    
    
    override func drawRect(rect: CGRect) {
        let context: CGContextRef = UIGraphicsGetCurrentContext()

        let locs: [CGFloat] = [0.0, 1.0]
        let firstColor: [CGFloat] = _gradientColor
        var secondColor: [CGFloat] =  _gradientColor.map { (item) -> CGFloat in item - 0.2}
        //alpha value is set back to 1 here
        secondColor[3] = 1.0

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
