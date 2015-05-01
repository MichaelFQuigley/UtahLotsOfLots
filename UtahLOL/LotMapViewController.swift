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

        if _lot!.mapPolygon != nil
        {
            var annotation = _lot!.mapPolygon!
            annotation.title    = _lot?.name
            annotation.subtitle = _lot?.address
            
            _mapView?.addAnnotation(annotation)
            _mapView?.selectAnnotation(annotation, animated: false)
            _mapView?.addOverlay(annotation)
        }
        
        view.addSubview(_mapView!)
        _multiCarSim = MulticarSim()
        _multiCarSim?.delegate = self
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        var titleLabel = AppUtil.getThemeTitleLabelWithWidth(self.view.frame.width)
        titleLabel.text = _lot!.name
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }
    
    
    
    override func viewDidDisappear(animated: Bool) {
        _multiCarSim?.stopSim()
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
    
    
    
    func lotOverlayColor(lot: LotData) -> UIColor
    {
        var trafficLevelStr = lot.getTrafficLevelStr(NSDate().timeIntervalSince1970)
        
        if trafficLevelStr == "Empty"
        {
            return UIColor.greenColor()
        }
        else if trafficLevelStr == "Moderate"
        {
            return UIColor.yellowColor()
        }
        else if trafficLevelStr == "Busy"
        {
            return UIColor.orangeColor()
        }
        else if trafficLevelStr == "Packed"
        {
            return UIColor.redColor()
        }
        else
        {
            return UIColor.grayColor()
        }
    }
    
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {

        var annotView = MKAnnotationView(annotation: annotation, reuseIdentifier: "abc")
        
        if annotation.title == "car"
        {
            annotView.image = ImageUtil.imageWithName("carIcon-256.png", size: CGSizeMake(40.0, 40.0))
            annotView.canShowCallout = true
        }
        else if annotation.isKindOfClass(MKUserLocation)
        {
            return nil
        }
        else if annotation.isKindOfClass(MKPolygon)
        {
            annotView.canShowCallout = true
        }
        else
        {
            return nil
        }
        
        return annotView
    }
    
    
    
    func mapView(mapView: MKMapView!, viewForOverlay overlay: MKOverlay!) -> MKOverlayView! {
        
        if let polygon : MKPolygon? =  overlay as? MKPolygon
        {
            var polyView = MKPolygonView(overlay: polygon!)
            
            return polyView
        }
        
        return nil
    }
    
    
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
    if overlay is MKPolygon
    {
        var polyRenderer = MKPolygonRenderer(overlay: overlay)
        polyRenderer.fillColor = lotOverlayColor(_lot!)
        return polyRenderer
    }
    
    return nil
    }
}
