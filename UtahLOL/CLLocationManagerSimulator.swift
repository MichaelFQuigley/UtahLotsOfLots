//
//  CLLocationManagerSimulator.swift
//  UtahLOL
//
//  Created by Nite Out on 4/15/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit
import CoreLocation

class CLLocationManagerSimulator: NSObject {
    weak var delegate: CLLocationManagerDelegate? = nil
    var desiredAccuracy: CLLocationAccuracy! = nil

    private var _updateTimer: NSTimer? = nil
    private var _timerInterval: NSTimeInterval = 0.3

    //numPoints represents number of points from current point to next point, ignored for last point in locationsArray
    //all coords must increase for now
    var locationsArray: [(location: CLLocationCoordinate2D, numPoints: Double)]!
    private var _currentLocation: CLLocationCoordinate2D?
    private var _regions: [(region: CLCircularRegion, inside: Bool)] = []
    //dummy location manager needed for passing into delegates
    private let tempMan: CLLocationManager = CLLocationManager()

    override init()
    {
        super.init()
      //  locationsArray = createLocArrayFromCoord(CLLocationCoordinate2D(latitude: 40.75964, longitude: -111.851129)) //StadiumLot
        locationsArray = createLotLeftArrayFromCoord(CLLocationCoordinate2D(latitude: 40.770102, longitude: -111.846256)) //MEBLot
    }
    

    
    func requestAlwaysAuthorization()
    {
        return
    }
    
    
    func createLotLeftArrayFromCoord(coord: CLLocationCoordinate2D) -> [(location: CLLocationCoordinate2D, numPoints: Double)]
    {
        var numPoints: Int = 300
        var lowLonCoord = LocationPathCreator.lonCoordforSpeed(coord.latitude,
                                                        lon_deg: coord.longitude,
                                                        speed_mph: 20.0,
                                                        timerInterval: _timerInterval,
                                                        numPoints: numPoints,
                                                        higherCoord: false)
        var highLonCoord = LocationPathCreator.lonCoordforSpeed(coord.latitude,
                                                        lon_deg: coord.longitude,
                                                        speed_mph: 7.0,
                                                        timerInterval: _timerInterval,
                                                        numPoints: numPoints,
                                                        higherCoord: true)
        //coord.longitude - 0.001
        return [
            (location: CLLocationCoordinate2D(latitude: coord.latitude - 0.00000001, longitude: lowLonCoord), numPoints: Double(numPoints)),
            (location: CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude), numPoints: Double(numPoints)),
            (location: CLLocationCoordinate2D(latitude: coord.latitude + 0.001, longitude: highLonCoord), numPoints: 100.0),
        ]
    }
    
    
    func createLotVisitedArrayFromCoord(coord: CLLocationCoordinate2D) -> [(location: CLLocationCoordinate2D, numPoints: Double)]
    {
        return [
            (location: CLLocationCoordinate2D(latitude: coord.latitude - 0.001, longitude: coord.longitude - 0.0013), numPoints: 100.0),
            (location: CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude), numPoints: 1500.0),
            (location: CLLocationCoordinate2D(latitude: coord.latitude + 0.00017, longitude: coord.longitude + 0.0108), numPoints: 100.0),
        ]
    }
    
    
    
    func checkIfRegionsEnteredOrExited(location: CLLocationCoordinate2D)
    {
        for var i = 0; i < _regions.count; i++
        {
            var pointA = CLLocation(latitude:  _regions[i].region.center.latitude, longitude: _regions[i].region.center.longitude)
            var pointB = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
            if pointA.distanceFromLocation(pointB) < _regions[i].region.radius && _regions[i].inside == false
            {
                    _regions[i].inside = true
                   delegate?.locationManager!(tempMan, didEnterRegion: _regions[i].region)
            }
            else if pointA.distanceFromLocation(pointB) >= _regions[i].region.radius && _regions[i].inside == true
            {
                _regions[i].inside = false
                delegate?.locationManager!(tempMan, didExitRegion: _regions[i].region)
            }
        }
    }
    
    
    
    func timer_IRQ()
    {
        if locationsArray.count <= 1
        {
            return
        }
        
        if _currentLocation == nil
        {
            _currentLocation = locationsArray[0].location
        }
        
        var latInterval  = (locationsArray[1].location.latitude - locationsArray[0].location.latitude) / locationsArray[0].numPoints
        var longInterval = (locationsArray[1].location.longitude - locationsArray[0].location.longitude) / locationsArray[0].numPoints
        _currentLocation?.latitude += latInterval
        _currentLocation?.longitude += longInterval

        var tempSpeed = CLLocation(latitude: 0.0,
            longitude: 0.0).distanceFromLocation(CLLocation(latitude: latInterval,
                longitude: longInterval)) / _timerInterval
        
        var tempLocation = CLLocation(latitude: _currentLocation!.latitude, longitude: _currentLocation!.longitude)
        tempLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: _currentLocation!.latitude, longitude: _currentLocation!.longitude),
                                        altitude: CLLocationDistance(),
                                        horizontalAccuracy: CLLocationAccuracy(),
                                        verticalAccuracy: CLLocationAccuracy(),
                                        course: CLLocationDirection(),
                                        speed: tempSpeed,
                                        timestamp: NSDate())

        delegate?.locationManager!(tempMan, didUpdateLocations: [tempLocation])
        
        checkIfRegionsEnteredOrExited(_currentLocation!)
        
        if _currentLocation?.latitude >= locationsArray[1].location.latitude || _currentLocation?.longitude >= locationsArray[1].location.longitude
        {
            locationsArray.removeAtIndex(0)
            _currentLocation = locationsArray[0].location
        }
        
    }
    
    
    
    func startMonitoringForRegion(region: CLCircularRegion)
    {
        let tup = (region: region, inside: false)
        _regions.append(tup)
    }
    
    
    
    func startUpdatingLocation()
    {
        _updateTimer = NSTimer(timeInterval: _timerInterval,
            target: self,
            selector: "timer_IRQ",
            userInfo: nil,
            repeats: true)
        
        NSRunLoop.currentRunLoop().addTimer(_updateTimer!, forMode: NSDefaultRunLoopMode)
        return
    }
}
