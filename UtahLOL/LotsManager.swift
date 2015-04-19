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
        case Name        = "Name"
        case Address     = "Address"
        case IsELot      = "IsELot"
        case IsALot      = "IsALot"
        case IsULot      = "IsULot"
        case ParkedTimes = "ParkedTimes"
        case LeftTimes   = "LeftTimes"
        case Location    = "Location"
        //GeoRegion has format {"coords": [lat, long], "radius": radius}
        case GeoRegion   = "GeoRegion"
    }
    
    
    
    class func lotDataFromPFObject(obj: PFObject) -> LotData
    {
        var tempLot = LotData()
        
        tempLot.address = obj[LotsClassFields.Address.rawValue] as String?
        tempLot.name    = obj[LotsClassFields.Name.rawValue] as String?
        tempLot.lotId   = obj.objectId
        tempLot.lotTypeFlags |= (obj[LotsClassFields.IsELot.rawValue] as Bool) ? LotData.PrimaryLotTag.eLot.rawValue : 0
        tempLot.lotTypeFlags |= (obj[LotsClassFields.IsALot.rawValue] as Bool) ? LotData.PrimaryLotTag.aLot.rawValue : 0
        tempLot.lotTypeFlags |= (obj[LotsClassFields.IsULot.rawValue] as Bool) ? LotData.PrimaryLotTag.uLot.rawValue : 0
        
        
        if let parkedTimes: [UInt] = obj[LotsClassFields.ParkedTimes.rawValue] as? [UInt]
        {
            tempLot.parkedTimes = parkedTimes
        }
        if let leftTimes: [UInt] = obj[LotsClassFields.LeftTimes.rawValue] as? [UInt]
        {
            tempLot.leftTimes = leftTimes
        }
        
        if let geoRegion: NSDictionary = obj[LotsClassFields.GeoRegion.rawValue] as? NSDictionary
        {
            var centerCoords: [Double] = geoRegion["coords"] as [Double]
            var center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: centerCoords[0], longitude: centerCoords[1])
            var radius: Double = geoRegion["radius"] as Double

            tempLot.lotRegion = CLCircularRegion(center: center,
                                                radius: radius,
                                                identifier: obj.objectId)
        }
        
        return tempLot
    }
    
    
    
    class func sortEmptiestLots(lotsArr: [LotData]) -> [LotData]
    {
        let hoursThreshold: Float = 2.1
        var sortedArr: [LotData]  = lotsArr
        let currentTime: UInt = 5//= UInt(NSDate().timeIntervalSince1970 * 1000)
        
        var timesScore = {(parkTimes: [UInt],scoreOperation: (val: Int) -> Int) -> Int in
            var score: Int = 0
            for parkTime in parkTimes
            {
                if Float(currentTime - parkTime) / 1000.0 <= hoursThreshold
                {
                    score = scoreOperation(val: score)
                }
            }
            return score
        }
        
        sortedArr.sort { (a, b) -> Bool in
            var aScore: Int = timesScore(a.parkedTimes, {(val: Int) -> Int in val - 1})
                + timesScore(a.leftTimes, {(val: Int) -> Int in val + 1})
            var bScore: Int = timesScore(b.parkedTimes, {(val: Int) -> Int in val - 1})
                + timesScore(b.leftTimes, {(val: Int) -> Int in val + 1})
          
            return aScore > bScore
        }
        
        return sortedArr
    }
    
    
    
    class func getNearestLotsOfType(type: LotData.PrimaryLotTag, location: CLLocation,  offset: Int, number: Int, completion: (lots: [LotData]) -> Void)
    {
        var lotsQuery = PFQuery(className: LotsClass)
        
        lotsQuery!.skip = offset
        if number != -1
        {
            lotsQuery!.limit = number
        }
        
        lotsQuery = filterLotQueryOnType(type, query: lotsQuery)
        
        var geoPoint: PFGeoPoint = PFGeoPoint(location: location)
        
        lotsQuery.whereKey(LotsClassFields.Location.rawValue, nearGeoPoint: geoPoint)
        
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
    
    
    
    //since processing of emptiest lots is done locally, all lots needs to be downloaded then sorted
    class func getEmptiestLotsOfType(type: LotData.PrimaryLotTag,  offset: Int, number: Int, completion: (lots: [LotData]) -> Void)
    {
        var lotsQuery = PFQuery(className: LotsClass)
        
        lotsQuery = filterLotQueryOnType(type, query: lotsQuery)
        
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
                
                completion(lots: self.sortEmptiestLots(lotsList))
            }
        }
    }
    
    
    
    class func filterLotQueryOnType(type: LotData.PrimaryLotTag, query: PFQuery) -> PFQuery
    {
        if type == LotData.PrimaryLotTag.eLot
        {
            query.whereKey(LotsClassFields.IsELot.rawValue, equalTo: true)
        }
        else if type == LotData.PrimaryLotTag.aLot
        {
            query.whereKey(LotsClassFields.IsALot.rawValue, equalTo: true)
        }
        else if type == LotData.PrimaryLotTag.uLot
        {
            query.whereKey(LotsClassFields.IsULot.rawValue, equalTo: true)
        }
        
        return query
    }
    
    
    
    //if number = -1, then limit is set to default limit
    class func getAllLotsOfType(type: LotData.PrimaryLotTag,  offset: Int, number: Int, completion: (lots: [LotData]) -> Void)
    {
        var lotsQuery = PFQuery(className: LotsClass)
        
        lotsQuery!.skip = offset
        if number != -1
        {
            lotsQuery!.limit = number
        }
        
        lotsQuery = filterLotQueryOnType(type, query: lotsQuery)
        
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
