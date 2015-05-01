//
//  LotsManager.swift
//  FinalProjectUtahLOL
//
//  Created by Nite Out on 4/14/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit
import Parse
import MapKit

class LotsManager: NSObject {
    
    class var LotsClass: String {return "Lots"}
    
    class var oldestParkTime_sec: NSTimeInterval {return 3600.0*3.0}
    
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
        case MapPolygon  = "MapPolygon"
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
        
        
        if let parkedTimes: [Double] = obj[LotsClassFields.ParkedTimes.rawValue] as? [Double]
        {
            tempLot.parkedTimes = parkedTimes
        }
        if let leftTimes: [Double] = obj[LotsClassFields.LeftTimes.rawValue] as? [Double]
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
        
        if let mapPolyArr: NSArray = obj[LotsClassFields.MapPolygon.rawValue] as? NSArray
        {
           // var coordinates: [CLLocationCoordinate2D] = []
            
            for coord in mapPolyArr
            {
                tempLot.polyCoords.append(CLLocationCoordinate2D(latitude: coord[0] as Double, longitude: coord[1] as Double))
            }
            tempLot.mapPolygon = MKPolygon(coordinates: &tempLot.polyCoords, count: tempLot.polyCoords.count)
        }
        
        return tempLot
    }
    
    
    
    class func sortEmptiestLots(lotsArr: [LotData]) -> [LotData]
    {
        var sortedArr: [LotData]  = lotsArr
        let currentTime: Double   = NSDate().timeIntervalSince1970
        
        sortedArr.sort { (a, b) -> Bool in

            return a.lotTimeScore(currentTime) > b.lotTimeScore(currentTime)
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
        
       // lotsQuery = filterLotQueryOnType(type, query: lotsQuery)
        
        var geoPoint: PFGeoPoint = PFGeoPoint(location: location)
        
        lotsQuery.whereKey(LotsClassFields.Location.rawValue, nearGeoPoint: geoPoint)
        
        lotsQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil{
                var lotsList = [LotData]()
                
                if let objects = objects as? [PFObject]
                {
                    for object in objects
                    {
                        //must filter by type manually since extra contraints with a geoPoint query does not appear to be supported
                        if type == LotData.PrimaryLotTag.allLot
                        {
                            lotsList.append(self.lotDataFromPFObject(object))
                        }
                        else if type == LotData.PrimaryLotTag.eLot
                            && object.objectForKey(LotsClassFields.IsELot.rawValue) as Bool == true
                        {
                            lotsList.append(self.lotDataFromPFObject(object))
                        }
                        else if type == LotData.PrimaryLotTag.aLot
                            && object.objectForKey(LotsClassFields.IsALot.rawValue) as Bool == true
                        {
                            lotsList.append(self.lotDataFromPFObject(object))
                        }
                        else if type == LotData.PrimaryLotTag.uLot
                            && object.objectForKey(LotsClassFields.IsULot.rawValue) as Bool == true
                        {
                            lotsList.append(self.lotDataFromPFObject(object))
                        }
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
    
    
    
    class func deleteOldTimesFromArray(timesArr: [Double], currentTime: Double) -> [Double]
    {
        var resultArr: [Double] = []
        for var i = 0; i < timesArr.count; i++
        {
            if (currentTime - timesArr[i]) <= oldestParkTime_sec
            {
                resultArr.append(timesArr[i])
            }
        }
        
        return resultArr
    }
    
    
    
    class func markLotAsParked(identifier: String, time: NSTimeInterval)
    {
        var query = PFQuery(className:LotsClass)
        query.getObjectInBackgroundWithId(identifier) {
            (object: PFObject!, error: NSError!) -> Void in
            if error == nil && object != nil {
                var parkedTimesArr: [Double]? = object.objectForKey(LotsClassFields.ParkedTimes.rawValue) as? [Double]
                
                if parkedTimesArr == nil
                {
                    parkedTimesArr = []
                }
                parkedTimesArr = self.deleteOldTimesFromArray(parkedTimesArr!, currentTime: time)
                parkedTimesArr?.append(time)
                
                object.setObject(parkedTimesArr!, forKey: LotsClassFields.ParkedTimes.rawValue)
                object.saveInBackgroundWithBlock({ (success, error) -> Void in })
                
            } else {
                println(error)
            }
        }
    }
    
    
    
    class func markLotAsLeft(identifier: String, time: NSTimeInterval)
    {
        var query = PFQuery(className:LotsClass)
        query.getObjectInBackgroundWithId(identifier) {
            (object: PFObject!, error: NSError!) -> Void in
            if error == nil && object != nil {
                var leftTimesArr: [Double]? = object.objectForKey(LotsClassFields.LeftTimes.rawValue) as? [Double]
                
                if leftTimesArr == nil
                {
                    leftTimesArr = []
                }
                leftTimesArr = self.deleteOldTimesFromArray(leftTimesArr!, currentTime: time)
                leftTimesArr?.append(time)
                
                object.setObject(leftTimesArr!, forKey: LotsClassFields.LeftTimes.rawValue)
                object.saveInBackgroundWithBlock({ (success, error) -> Void in })
                
            } else {
                println(error)
            }
        }
    }
    
    
}
