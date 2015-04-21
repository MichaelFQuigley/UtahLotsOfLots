//
//  LocationPathCreator.swift
//  UtahLOL
//
//  Created by Nite Out on 4/21/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import CoreLocation

class LocationPathCreator: NSObject {
    
    //shouldVisit = true if simulated car visits lot, false if it leaves lot
    class func createLocPathStructFromCoord(coord: CLLocationCoordinate2D, shouldVisit: Bool, _timerInterval: Double) -> LocationPath
    {
        var higherSpeed: Double = 20.0
        var lowerSpeed:  Double = 5.5
        var numPoints: Int      = 300
        var lowLonCoord = lonCoordforSpeed(coord.latitude,
            lon_deg: coord.longitude,
            speed_mph: shouldVisit ? higherSpeed : lowerSpeed,
            timerInterval: _timerInterval,
            numPoints: numPoints,
            higherCoord: false)
        var highLonCoord = lonCoordforSpeed(coord.latitude,
            lon_deg: coord.longitude,
            speed_mph: shouldVisit ? lowerSpeed : higherSpeed,
            timerInterval: _timerInterval,
            numPoints: numPoints,
            higherCoord: true)
        
        
        var initialLocation = CLLocationCoordinate2D(latitude: coord.latitude - 0.00000001, longitude: lowLonCoord)
        var locationArray = [
            (location: initialLocation, numPoints: Double(numPoints)),
            (location: CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude), numPoints: Double(numPoints)),
            (location: CLLocationCoordinate2D(latitude: coord.latitude + 0.00000001, longitude: highLonCoord), numPoints: Double(numPoints)),
        ]
        
        return LocationPath(locationsArray: locationArray, currentLocation: initialLocation)
    }
    
    class func lonCoordforSpeed(lat_deg: Double, lon_deg: Double, speed_mph: Double, timerInterval: Double, numPoints: Int, higherCoord: Bool) -> Double
    {
        var metersPerSec: Double = 0.44704 * (speed_mph / 1.32)
        
        var dist: Double = (metersPerSec * timerInterval) * Double(numPoints)
        
        return lonCoordFromDist(lat_deg, lon_deg: lon_deg, dist: dist, higherCoord: higherCoord)
    }
    
    
    
    //distance provided in meters
    class func lonCoordFromDist(lat_deg: Double, lon_deg: Double, dist: Double, higherCoord: Bool) -> Double
    {
        var radToDeg = {(rad: Double) -> Double in
            return rad * 180.0 / M_PI
        }
        
        var degToRad = {(deg: Double) -> Double in
            return deg * M_PI / 180.0
        }
        
        var lat = degToRad(lat_deg)
        var lon = degToRad(lon_deg)
        
        let R: Double = 6373000.0 // in meters
        var a: Double = tan(dist / (2.0 * R))
        
        var result: Double =  higherCoord ? lon + 2.0 * asin(a / ((1 + a) * cos(lat))) : lon - 2.0 * asin(a / ((1 + a) * cos(lat)))
        
        return radToDeg(result)
    }
}
