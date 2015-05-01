//
//  LoadingView.swift
//  FinalProjectUtahLOL
//
//  Created by Nite Out on 4/8/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    private var _loadingLabel: UILabel?
    private var _loadingWheel: UIActivityIndicatorView?
    
    override init()
    {
        super.init()
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    override func layoutSubviews() {
        var cursor: CGPoint  = CGPointMake(frame.origin.x, frame.origin.y + frame.height / 5.0)
        let vMargin: CGFloat = 12.0
        
        backgroundColor = UIColor.lightGrayColor()
        
        _loadingLabel = UILabel(frame: CGRectMake(cursor.x,
            cursor.y,
            frame.width,
            frame.height / 6.0))
        _loadingLabel?.textAlignment = NSTextAlignment.Center
        _loadingLabel?.text          = "Loading..."
        _loadingLabel?.font          = UIFont(name: AppUtil.themeFont, size: 24.0)
        cursor.y += _loadingLabel!.frame.height
        
        var wheelDim: CGFloat = max(frame.height / 6.0, frame.width / 6.0)
        
        _loadingWheel = UIActivityIndicatorView(frame: CGRectMake(cursor.x + (frame.width - wheelDim) / 2.0,
            cursor.y,
            wheelDim,
            wheelDim))
        _loadingWheel?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        _loadingWheel?.startAnimating()
        _loadingWheel?.hidesWhenStopped = false
        
        cursor.y += _loadingWheel!.frame.height
        
        addSubview(_loadingLabel!)
        addSubview(_loadingWheel!)
    }
}
