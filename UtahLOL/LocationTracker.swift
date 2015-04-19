//
//  LocationTracker.swift
//  UtahLOL
//
//  Created by Nite Out on 4/15/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationTrackerDelegate: class
{
    //called when region is entered with speed <= lowSpeed_mph and left with speed >= highSpeed_mph
    func trackedRegionLeft(region: CLRegion)
    //called when region is left with speed <= lowSpeed_mph and entered with speed >= highSpeed_mph
    func trackedRegionVisited(region: CLRegion)
}



class LocationTracker: NSObject, CLLocationManagerDelegate {
    weak var delegate: LocationTrackerDelegate? = nil
    var locationManager: CLLocationManagerSimulator?
    private var _latestLocation: CLLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    
    var latestLocation: CLLocation{return _latestLocation}
    //taken since time since 1970
    private var _lastUpdatedTimestamp: NSTimeInterval = 0.0
    private let _deltaT_seconds: Double               = 1.0
    
    private var _lots: [LotData] = [LotData]()
    
    var latestVelocity: Double{return _latestLocation.speed}
    //georegion must be entered at speed >= to entry speed to be considered
    var highSpeed_mph: Double = 10.0
    //georegion must be left at speed <= to be considered
    var lowSpeed_mph: Double  = 7.0
    //number of elements that must satisfy a condition in the velocityQueue in order to be considered a leave or enter event
    let numElementsForEstimate: UInt = 7
    
    
    class var maxQueueSize: UInt  {return 10}
    
    var currentVelocityQueue: VelocityQueue<Double> = VelocityQueue<Double>(maxSize: maxQueueSize)
    
    var enteredVelocityQueue: VelocityQueue<Double> = VelocityQueue<Double>(maxSize: maxQueueSize)
    var exitedVelocityQueue: VelocityQueue<Double>  = VelocityQueue<Double>(maxSize: maxQueueSize)
    
    var _lastEnteredRegionId: String = ""
    
    override init()
    {
        super.init()
        locationManager = CLLocationManagerSimulator()
        locationManager?.delegate        = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        
        LotsManager.getAllLotsOfType(LotData.PrimaryLotTag.allLot, offset: 0, number: -1) { (lots) -> Void in
            self._lots = lots
            
            for lot in self._lots
            {
                self.locationManager?.startMonitoringForRegion(lot.lotRegion)
            }
        }
    }
    
    
    
    func metersPerSecToMPH(mPerSec: Double) -> Double
    {
        return 2.23694 * mPerSec
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        _latestLocation = locations[0] as CLLocation
        
        if (_latestLocation.timestamp.timeIntervalSince1970 - _lastUpdatedTimestamp) >= _deltaT_seconds
        {
            _lastUpdatedTimestamp = _latestLocation.timestamp.timeIntervalSince1970
            currentVelocityQueue.enqueue(metersPerSecToMPH(_latestLocation.speed))
            println(currentVelocityQueue.items)
            println(_latestLocation.coordinate.latitude)
            println(_latestLocation.coordinate.longitude)
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        _lastEnteredRegionId = region.identifier
        enteredVelocityQueue = currentVelocityQueue.vCopy()
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        if region.identifier == _lastEnteredRegionId
        {
            exitedVelocityQueue = currentVelocityQueue.vCopy()
            
            //entered event
            if enteredVelocityQueue.numItemsRelativeToOperator({ (item) -> Bool in item >= self.highSpeed_mph}) >= numElementsForEstimate &&
            exitedVelocityQueue.numItemsRelativeToOperator({ (item) -> Bool in item <= self.lowSpeed_mph}) >= numElementsForEstimate
            {
                delegate?.trackedRegionVisited(region)
            }
            //left event
            else if enteredVelocityQueue.numItemsRelativeToOperator({ (item) -> Bool in item <= self.lowSpeed_mph}) >= numElementsForEstimate &&
                exitedVelocityQueue.numItemsRelativeToOperator({ (item) -> Bool in item >= self.highSpeed_mph}) >= numElementsForEstimate
            {
                delegate?.trackedRegionLeft(region)
            }
        }
    }

}
