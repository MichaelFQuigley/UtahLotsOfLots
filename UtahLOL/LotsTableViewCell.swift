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
        
        
        var cursor: CGPoint = CGPointZero
        
        nameLabel?.frame = CGRectMake(cursor.x, cursor.y, frame.width, frame.height / 3.0)
        
        cursor.y += nameLabel!.frame.height
        
        addressLabel?.frame = CGRectMake(cursor.x, cursor.y, frame.width, 2.0 * frame.height / 3.0)
        
        cursor.x += addressLabel!.frame.width
        
        statusLabel?.frame = CGRectMake(cursor.x, cursor.y, frame.width, 2.0 * frame.height / 3.0)
        
        
    }
}
