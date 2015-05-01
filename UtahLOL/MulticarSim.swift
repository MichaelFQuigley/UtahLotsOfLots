//
//  MulticarSim.swift
//  UtahLOL
//
//  Created by Nite Out on 4/20/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import Parse

protocol MulticarSimDelegate: class
{
    func simulatorUpdatedCurrentLocations(locs: [CLLocationCoordinate2D])
}

class MulticarSim: NSObject{
    weak var delegate: MulticarSimDelegate? = nil
    private var _lots: [LotData]!
    private var _updateTimer: NSTimer!
    private let _timerInterval: NSTimeInterval = 0.3
    //numPoints represents number of points from current point to next point, ignored for last point in locationsArray
    //all coords must increase for now
    var locationStructs: [LocationPath] = []
    //georegion must be entered at speed >= to entry speed to be considered
    var highSpeed_mph: Double = 10.0
    //georegion must be left at speed <= to be considered
    var lowSpeed_mph: Double  = 7.0
    //number of elements that must satisfy a condition in the velocityQueue in order to be considered a leave or enter event
    let numElementsForEstimate: UInt = 7
    var _lastUpdatedTimestamp: Double = 0.0
    //amount of time between updating each path's velocity queue
    private let _deltaT_seconds: Double = 1.0
    
    override init()
    {
        super.init()
        _lastUpdatedTimestamp = NSDate().timeIntervalSince1970
        _lots = []
        startSim()
    }

    
    
    func regionEntered(region: CLCircularRegion, locationStructIndex: Int)
    {
        locationStructs[locationStructIndex].enteredVelocityQueue = locationStructs[locationStructIndex].currentVelocityQueue.vCopy()
    }
    
    
    
    func regionExited(region: CLCircularRegion, locationStructIndex: Int)
    {
        locationStructs[locationStructIndex].exitedVelocityQueue = locationStructs[locationStructIndex].currentVelocityQueue.vCopy()
        
        //entered event
        if locationStructs[locationStructIndex].enteredVelocityQueue.numItemsRelativeToOperator({ (item) -> Bool in item >= self.highSpeed_mph})
            >= numElementsForEstimate
            && locationStructs[locationStructIndex].exitedVelocityQueue.numItemsRelativeToOperator({ (item) -> Bool in item <= self.lowSpeed_mph})
            >= numElementsForEstimate
        {
            LotsManager.markLotAsParked(region.identifier, time: NSDate().timeIntervalSince1970)
        }
            //left event
        else if locationStructs[locationStructIndex].enteredVelocityQueue.numItemsRelativeToOperator({ (item) -> Bool in item <= self.lowSpeed_mph})
            >= numElementsForEstimate
            &&
            locationStructs[locationStructIndex].exitedVelocityQueue.numItemsRelativeToOperator({ (item) -> Bool in item >= self.highSpeed_mph})
            >= numElementsForEstimate
        {
            LotsManager.markLotAsLeft(region.identifier, time: NSDate().timeIntervalSince1970)
        }
    }
    
    
    
    func checkIfRegionEnteredOrExited(locationStructIndex: Int)///(location: CLLocationCoordinate2D)
    {
        for var i = 0; i < _lots.count; i++
        {
            var pointA = CLLocation(latitude:  _lots[i].lotRegion.center.latitude, longitude: _lots[i].lotRegion.center.longitude)
            var pointB = CLLocation(latitude: locationStructs[locationStructIndex].currentLocation!.latitude,
                                    longitude: locationStructs[locationStructIndex].currentLocation!.longitude)
            
            if (pointA.distanceFromLocation(pointB) < _lots[i].lotRegion.radius)
                && (!locationStructs[locationStructIndex].inRegion(_lots[i].lotRegion))
            {
                locationStructs[locationStructIndex].enterRegion(_lots[i].lotRegion)
                println("\(_lots[i].name) entered")
                regionEntered(_lots[i].lotRegion, locationStructIndex: locationStructIndex)
            }
            else if (pointA.distanceFromLocation(pointB) >= _lots[i].lotRegion.radius)
                && locationStructs[locationStructIndex].inRegion(_lots[i].lotRegion)
            {
                println("\(_lots[i].name) exited")
                println(pointA.distanceFromLocation(pointB))
                locationStructs[locationStructIndex].exitRegion(_lots[i].lotRegion)
                regionExited(_lots[i].lotRegion, locationStructIndex: locationStructIndex)
            }
        }
    }
    
    
    
    func timer_IRQ()
    {
        var timeStamp: Double = NSDate().timeIntervalSince1970
        
        for var i = 0; i < locationStructs.count; i++ //locationStruct in locationStructs
        {
            var locationStruct = locationStructs[i]
            
            if locationStruct.locationsArray.count <= 1
            {
                return
            }
            
            var latInterval: Double  = (locationStruct.locationsArray[1].location.latitude - locationStruct.locationsArray[0].location.latitude)
                                / locationStruct.locationsArray[0].numPoints
            var longInterval: Double = (locationStruct.locationsArray[1].location.longitude - locationStruct.locationsArray[0].location.longitude)
                                / locationStruct.locationsArray[0].numPoints
            locationStruct.currentLocation!.latitude += latInterval
            locationStruct.currentLocation!.longitude += longInterval
            
            var tempSpeed = CLLocation(latitude: 0.0,
                longitude: 0.0).distanceFromLocation(CLLocation(latitude: latInterval,
                    longitude: longInterval)) / _timerInterval
            
            var tempLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: locationStruct.currentLocation!.latitude,
                                                                            longitude: locationStruct.currentLocation!.longitude),
                                                                            altitude: CLLocationDistance(),
                                                                            horizontalAccuracy: CLLocationAccuracy(),
                                                                            verticalAccuracy: CLLocationAccuracy(),
                                                                            course: CLLocationDirection(),
                                                                            speed: tempSpeed,
                                                                            timestamp: NSDate())
            
            locationStruct.currentSpeed = tempSpeed
            
            checkIfRegionEnteredOrExited(i)
            
            if locationStruct.currentLocation!.latitude >= locationStruct.locationsArray[1].location.latitude
                || locationStruct.currentLocation!.longitude >= locationStruct.locationsArray[1].location.longitude
            {
                locationStruct.locationsArray.removeAtIndex(0)
                locationStruct.currentLocation = locationStruct.locationsArray[0].location
            }
        }
        
        if (timeStamp - _lastUpdatedTimestamp) >= _deltaT_seconds
        {
            _lastUpdatedTimestamp = timeStamp
            for var i = 0; i < locationStructs.count; i++
            {
                locationStructs[i].currentVelocityQueue.enqueue(metersPerSecToMPH(locationStructs[i].currentSpeed))
            }
            delegate?.simulatorUpdatedCurrentLocations(locationStructs.map({ (lotStruct: LocationPath) -> CLLocationCoordinate2D in
                lotStruct.currentLocation!
            }))
        }
        
    }
    
    
    
    func metersPerSecToMPH(mPerSec: Double) -> Double
    {
        return 2.23694 * mPerSec
    }
    
    
    
    func generateLotArrays()
    {
        var shouldVisit: Bool!
        
        for lot in _lots
        {
            shouldVisit = (Int(arc4random_uniform(4))  % 2) == 0
            
            locationStructs.append(LocationPathCreator.createLocPathStructFromCoord(lot.lotRegion.center,
                                                                                    shouldVisit: shouldVisit,
                                                                                    _timerInterval: _timerInterval))
        }
    }
    
    
    
    func startSim()
    {
        LotsManager.getAllLotsOfType(LotData.PrimaryLotTag.allLot, offset: 0, number: -1) { (lots) -> Void in
            self._lots = lots
            
            self.generateLotArrays()
            
            self._updateTimer = NSTimer(timeInterval: self._timerInterval,
                target: self,
                selector: "timer_IRQ",
                userInfo: nil,
                repeats: true)
            
            NSRunLoop.currentRunLoop().addTimer(self._updateTimer!, forMode: NSDefaultRunLoopMode)
        }
    }
    
    
    
    func stopSim()
    {
        _updateTimer.invalidate()
    }
}
