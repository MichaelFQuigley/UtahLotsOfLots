//
//  LotData.swift
//  FinalProjectUtahLOL
//
//  Created by Nite Out on 4/14/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LotData: NSObject, MKAnnotation {
    
    var name: String?
    var address: String?
    var lotId: String?
    var lotStatus: LotStatus?
    var lotTypeFlags: Int = 0
    var parkedTimes: [Double] = []
    var leftTimes:   [Double] = []
    var lotRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
                                                        radius: 0.0,
                                                        identifier: "")
    var mapPolygon: MKPolygon? = nil
    var polyCoords: [CLLocationCoordinate2D] = []
    
    enum PrimaryLotTag: Int
    {
        case aLot = 1, eLot = 2, allLot = 4, uLot = 8
    }
    
    enum SecondaryButtonTag: Int{
        case AnyButton = 0, NearestButton, EmptiestButton, numSecButtons
    }
    
    enum LotStatus: Int
    {
        case Unknown = 0, Empty, Moderate, Busy, Packed
    }
    
    //number of parked plus left cars that need to surpass a certain threshold
    enum LotTrafficConfidenceLevel: Int
    {
        case Uncertain  = 0
        case Maybe      = 1
        case Probably   = 6
        case Definitely = 9
    }
    
    //higher amounts mean emptier
    enum LotTrafficAmountLevel: Int
    {
        case Empty    = 0
        case Moderate = -1
        case Busy     = -2
        case Packed   = -3
    }
    
    override init() {
        super.init()
    }
    
    
    
    var coordinate: CLLocationCoordinate2D
    {
        return lotRegion.center
    }
    
    
    var title: String!{
        return name!
    }
    
    
    var subtitle: String!{
        return address!
    }
    
    
    var confidenceLevelStr: String
    {
        var dataPointsCount = parkedTimes.count + leftTimes.count
        
        if dataPointsCount >= LotTrafficConfidenceLevel.Definitely.rawValue
        {
            return "Definitely"
        }
        else if dataPointsCount >= LotTrafficConfidenceLevel.Probably.rawValue
        {
            return "Probably"
        }
        else if dataPointsCount >= LotTrafficConfidenceLevel.Maybe.rawValue
        {
            return "Maybe"
        }
        
        return "No Data"
    }
    
    
    
    func getTrafficLevelStr(currentTime: Double) -> String {
        if confidenceLevelStr == "No Data"
        {
            return ""
        }
        
        var lotTimeSc = lotTimeScore(currentTime)
    
        if lotTimeSc >= LotTrafficAmountLevel.Empty.rawValue
        {
            return "Empty"
        }
        else if lotTimeSc >= LotTrafficAmountLevel.Moderate.rawValue
        {
            return "Moderate"
        }
        else if lotTimeSc >= LotTrafficAmountLevel.Busy.rawValue
        {
            return "Busy"
        }
        
        return "Packed"
    }
    
    
    
    func lotTimeScore(currentTime: Double) -> Int
    {
        let hoursThreshold: Double = 1.0
        var timesScore = {(parkTimes: [Double],scoreOperation: (val: Int) -> Int) -> Int in
            var score: Int = 0
            for parkTime in parkTimes
            {
                if (currentTime - parkTime) / 3600.0 <= hoursThreshold
                {
                    score = scoreOperation(val: score)
                }
            }
            return score
        }
        
        return timesScore(self.parkedTimes, {(val: Int) -> Int in val - 1}) + timesScore(self.leftTimes, {(val: Int) -> Int in val + 1})
    }
    
    
    
    func setCoordinate(newCoordinate: CLLocationCoordinate2D)
    {
        return
    }
}
