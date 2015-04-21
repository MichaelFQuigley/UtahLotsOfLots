//
//  LocationPath.swift
//  UtahLOL
//
//  Created by Nite Out on 4/21/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import CoreLocation

class LocationPath
{
    class var maxQueueSize: UInt {return 10}
    var locationsArray:[(location: CLLocationCoordinate2D, numPoints: Double)]!
    var currentLocation: CLLocationCoordinate2D?
    var currentSpeed: Double = 0.0
    var enteredVelocityQueue: VelocityQueue<Double> = VelocityQueue<Double>(maxSize: maxQueueSize)
    var currentVelocityQueue: VelocityQueue<Double> = VelocityQueue<Double>(maxSize: maxQueueSize)
    var exitedVelocityQueue: VelocityQueue<Double> = VelocityQueue<Double>(maxSize: maxQueueSize)
    var _regionStr: String = ""
    
    init(locationsArray: [(location: CLLocationCoordinate2D, numPoints: Double)],currentLocation: CLLocationCoordinate2D)
    {
        self.locationsArray = locationsArray
        self.currentLocation = currentLocation
    }
    
    
    func enterRegion(region: CLCircularRegion)
    {
        _regionStr = region.identifier
    }
    
    
    
    func exitRegion(region: CLCircularRegion)
    {
        _regionStr = ""
    }
    
    
    
    func inRegion(region: CLCircularRegion) -> Bool{
        return region.identifier == _regionStr
    }
}