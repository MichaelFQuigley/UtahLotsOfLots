//
//  LotMapViewController.swift
//  UtahLOL
//
//  Created by Nite Out on 4/19/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit
import MapKit

class LotMapViewController: UIViewController, MKMapViewDelegate, MulticarSimDelegate {
    private var _lot: LotData?
    private var _locationTracker: LocationTracker?
    private var _mapView: MKMapView?
    private var _multiCarSim: MulticarSim?
    private var _simMapnnotations: [MKPointAnnotation]?
    
    override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(lot: LotData, locationTracker: LocationTracker){
        super.init()
        _lot = lot
        _locationTracker = locationTracker
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        _mapView = MKMapView(frame: self.view.frame)
        _mapView?.delegate          = self
        _mapView?.showsUserLocation = true

        var region = MKCoordinateRegion(center: _lot!.lotRegion.center, span: MKCoordinateSpanMake(0.01, 0.01))
        _mapView?.setRegion(region, animated: false)
        
        var annotation = MKPointAnnotation()
        annotation.setCoordinate(_lot!.lotRegion.center)
        annotation.title    = _lot?.name
        annotation.subtitle = _lot?.address
        
        _mapView?.addAnnotation(_lot!)
        view.addSubview(_mapView!)
        
        _multiCarSim = MulticarSim()
        _multiCarSim?.delegate = self
    }
    
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        var titleLabel = AppUtil.getThemeTitleLabelWithWidth(self.view.frame.width)
        titleLabel.text = _lot!.name
        self.navigationItem.titleView = titleLabel
    }
    
    
    func simulatorAnnotationsFromLocs(locs: [CLLocationCoordinate2D]) -> [MKPointAnnotation]
    {
        var resultArr: [MKPointAnnotation] = []
        
        for var i = 0; i < locs.count; i++
        {
            var annotation = MKPointAnnotation()
            annotation.setCoordinate(locs[i])
            annotation.title    = "car"
            annotation.subtitle = "beep beep"
            resultArr.append(annotation)
            
        }
        
        return resultArr
    }
    
    
    
    //multicar simulator delegate
    func simulatorUpdatedCurrentLocations(locs: [CLLocationCoordinate2D]) {
        if _simMapnnotations == nil
        {
            _simMapnnotations = simulatorAnnotationsFromLocs(locs)

            _mapView?.addAnnotations(_simMapnnotations)
        }
        
        for var i = 0; i < locs.count; i++
        {
            _simMapnnotations?[i].setCoordinate(locs[i])
        }
        
    }
    
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var annotView = MKAnnotationView(annotation: annotation, reuseIdentifier: "abc")
        
        if annotation.title == "car"
        {
            annotView.image = ImageUtil.imageWithName("carIcon-256.png", size: CGSizeMake(40.0, 40.0))
        }
        else if annotation.isKindOfClass(MKUserLocation)
        {
            return nil
        }
        else if annotation.isKindOfClass(LotData)
        {
            annotView.frame = CGRectMake(0, 0, 50, 50)
            
            var trafficLevelStr = _lot?.getTrafficLevelStr(NSDate().timeIntervalSince1970)

            if trafficLevelStr == "Empty"
            {
                annotView.backgroundColor = UIColor.greenColor()
            }
            else if trafficLevelStr == "Moderate"
            {
                annotView.backgroundColor = UIColor.yellowColor()
            }
            else if trafficLevelStr == "Busy"
            {
                annotView.backgroundColor = UIColor.orangeColor()
            }
            else if trafficLevelStr == "Packed"
            {
                annotView.backgroundColor = UIColor.redColor()
            }
            else
            {
                annotView.backgroundColor = UIColor.grayColor()
            }
            annotView.canShowCallout = true
        }
        else
        {
            return nil
        }
        
        return annotView
    }
    
    
}
