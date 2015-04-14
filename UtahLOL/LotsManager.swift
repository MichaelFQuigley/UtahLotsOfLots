//
//  LotsManager.swift
//  FinalProjectUtahLOL
//
//  Created by Nite Out on 4/14/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit
import Parse

class LotsManager: NSObject {
    
    class var LotsClass: String {return "Lots"}
    
    enum LotsClassFields: String
    {
        case Name    = "Name"
        case Address = "Address"
        case IsELot  = "IsELot"
        case IsALot  = "IsALot"
        case IsULot  = "IsULot"
    }
    
    
    
    class func lotDataFromPFObject(obj: PFObject) -> LotData
    {
        var tempLot = LotData()
        
        tempLot.address = obj[LotsClassFields.Address.rawValue] as String?
        tempLot.name    = obj[LotsClassFields.Name.rawValue] as String?
        tempLot.lotTypeFlags |= (obj[LotsClassFields.IsELot.rawValue] as Bool) ? LotData.PrimaryLotTag.eLot.rawValue : 0
        tempLot.lotTypeFlags |= (obj[LotsClassFields.IsALot.rawValue] as Bool) ? LotData.PrimaryLotTag.aLot.rawValue : 0
        tempLot.lotTypeFlags |= (obj[LotsClassFields.IsULot.rawValue] as Bool) ? LotData.PrimaryLotTag.uLot.rawValue : 0
        
        return tempLot
    }
    
    
    
    //if number = -1, then limit is set to default limit
    class func getAllLotsOfType(type: LotData.PrimaryLotTag, secondaryType: LotData.SecondaryButtonTag,  offset: Int, number: Int, completion: (lots: [LotData]) -> Void)
    {
        var lotsQuery = PFQuery(className: LotsClass)
        
        lotsQuery!.skip = offset
        if number != -1
        {
            lotsQuery!.limit = number
        }
        
        lotsQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil{
                var lotsList = [LotData]()
                
                if let objects = objects as? [PFObject]
                {
                    for object in objects
                    {
                        lotsList.append(self.lotDataFromPFObject(object))
                    }
                }
                
                completion(lots: lotsList)
            }
        }
    }
    
}
