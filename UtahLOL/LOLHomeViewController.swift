//
//  LOLHomeViewController.swift
//  FinalProjectUtahLOL
//
//  Created by Nite Out on 4/8/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit
import CoreLocation

class LOLHomeViewController: UIViewController, DropDownMenuViewDelegate, LocationTrackerDelegate {
    
    private var _allLotsElement: DropDownMenuView?
    private var _aLotsElement: DropDownMenuView?
    private var _eLotsElement: DropDownMenuView?
    private var _uLotsElement: DropDownMenuView?
    var locationTracker: LocationTracker?
    //vertical margin between buttons
    private var vMargin: CGFloat = 0.0
    private var secondaryButtonHeight: CGFloat = 0.0
    private var primaryButtonHeight: CGFloat   = 0.0
    
    override func viewDidLoad() {

        locationTracker = LocationTracker()
        locationTracker?.delegate = self
        view.backgroundColor = AppUtil.themeColor
        vMargin               = self.view.frame.height / 36.0
        primaryButtonHeight   = self.view.frame.height / 8.0
        secondaryButtonHeight = self.view.frame.height / 16.0
        
        
        var cursor: CGPoint = CGPointMake(view.frame.origin.x, view.frame.origin.y + self.view.frame.height / 8.0)
        
        var allLotsFrame = CGRectMake(cursor.x, cursor.y, self.view.frame.width, primaryButtonHeight)
        
        //difference in color between primary and secondary buttons for each RGB component
        let colorDifference: CGFloat = 42.0/255.0
        //dummy val used for alpha component when getting colors
        var dumyVal:CGFloat = 0.0
        
        var allLotsRedComp: CGFloat   = 0.0
        var allLotsGreenComp: CGFloat =  0.0
        var allLotsBlueComp: CGFloat  = 0.0
        
        
        UIColor.orangeColor().getRed(&allLotsRedComp, green: &allLotsGreenComp, blue: &allLotsBlueComp, alpha: &dumyVal)
        
        
        _allLotsElement = DropDownMenuView(frame: allLotsFrame,
            color: UIColor(red:allLotsRedComp,
                        green:allLotsGreenComp,
                        blue: allLotsBlueComp,
                        alpha: 1.0),
            name: "All",
            secondaryButtonHeight: secondaryButtonHeight)
        _allLotsElement?.delegate = self
        _allLotsElement?.secondaryButtonsColor  = UIColor(red:allLotsRedComp + colorDifference,
                                                        green:allLotsGreenComp + colorDifference,
                                                        blue: allLotsBlueComp + colorDifference,
                                                        alpha: 1.0)
        
        cursor.y += allLotsFrame.height + vMargin
        
        var aLotsFrame = CGRectMake(cursor.x, cursor.y, self.view.frame.width, primaryButtonHeight)
        
        var aLotsRedComp: CGFloat   = 0.0
        var aLotsGreenComp: CGFloat =  0.0
        var aLotsBlueComp: CGFloat  = 0.0

        
        UIColor.brownColor().getRed(&aLotsRedComp, green: &aLotsGreenComp, blue: &aLotsBlueComp, alpha: &dumyVal)
        
        _aLotsElement = DropDownMenuView(frame:aLotsFrame,
            color: UIColor(red:aLotsRedComp,
                        green:aLotsGreenComp,
                        blue: aLotsBlueComp,
                        alpha: 1.0),
            name: "A Lots",
            secondaryButtonHeight: secondaryButtonHeight)
        _aLotsElement?.delegate = self
        _aLotsElement?.secondaryButtonsColor = UIColor(red:aLotsRedComp + colorDifference,
                                                        green:aLotsGreenComp + colorDifference,
                                                        blue: aLotsBlueComp + colorDifference,
                                                        alpha: 1.0)
                                                    
        cursor.y += aLotsFrame.height + vMargin
        
        var eLotsFrame = CGRectMake(cursor.x, cursor.y, self.view.frame.width, primaryButtonHeight)

        let eLotsRedComp: CGFloat   = 65.0/255.0
        let eLotsGreenComp: CGFloat =  147.0/255.0
        let eLotsBlueComp: CGFloat  = 73.0/255.0
        
        _eLotsElement = DropDownMenuView(frame:eLotsFrame,
            color:  UIColor(red:eLotsRedComp,
                    green:eLotsGreenComp,
                    blue: eLotsBlueComp,
                    alpha: 1.0),
            name: "E Lots",
            secondaryButtonHeight: secondaryButtonHeight)
        _eLotsElement?.delegate = self
        _eLotsElement?.secondaryButtonsColor = UIColor(red:eLotsRedComp + colorDifference,
                                                            green:eLotsGreenComp + colorDifference,
                                                            blue: eLotsBlueComp + colorDifference,
                                                            alpha: 1.0)
        
        
        cursor.y += eLotsFrame.height + vMargin
        
        var uLotsFrame = CGRectMake(cursor.x, cursor.y, self.view.frame.width, primaryButtonHeight)
        
        var uLotsRedComp: CGFloat   = 0.0
        var uLotsGreenComp: CGFloat =  0.0
        var uLotsBlueComp: CGFloat  = 0.0
        
        UIColor.redColor().getRed(&uLotsRedComp, green: &uLotsGreenComp, blue: &uLotsBlueComp, alpha: &dumyVal)
        
        _uLotsElement = DropDownMenuView(frame:uLotsFrame,
            color: UIColor(red:uLotsRedComp,
                        green:uLotsGreenComp,
                        blue: uLotsBlueComp,
                        alpha: 1.0),
            name: "U Lots",
            secondaryButtonHeight: secondaryButtonHeight)
        _uLotsElement?.delegate = self
        _uLotsElement?.secondaryButtonsColor = UIColor(red:uLotsRedComp + colorDifference,
                                                        green:uLotsGreenComp + colorDifference,
                                                        blue: uLotsBlueComp + colorDifference,
                                                        alpha: 1.0)
        
        view.addSubview(_allLotsElement!)
        view.addSubview(_aLotsElement!)
        view.addSubview(_eLotsElement!)
        view.addSubview(_uLotsElement!)
    }
    
    
    
    func setButtonFramesAfterMenusChanged()
    {
        var cursor: CGPoint = CGPointMake(view.frame.origin.x, view.frame.origin.y + self.view.frame.height / 8.0)
        
        var allLotsFrame = CGRectMake(cursor.x, cursor.y, _allLotsElement!.frame.width, _allLotsElement!.frame.height)
        
        _allLotsElement?.frame = allLotsFrame
        
        cursor.y += allLotsFrame.height + vMargin
        
        var aLotsFrame = CGRectMake(cursor.x, cursor.y, _aLotsElement!.frame.width, _aLotsElement!.frame.height)
        
        _aLotsElement?.frame = aLotsFrame
        
        cursor.y += aLotsFrame.height + vMargin
        
        var eLotsFrame = CGRectMake(cursor.x, cursor.y,  _eLotsElement!.frame.width, _eLotsElement!.frame.height)
        
        _eLotsElement?.frame = eLotsFrame
        
        cursor.y += eLotsFrame.height + vMargin
        
        var uLotsFrame = CGRectMake(cursor.x, cursor.y, _uLotsElement!.frame.width, _uLotsElement!.frame.height)
        
        _uLotsElement?.frame = uLotsFrame
    }
    
    
    
    override func viewWillAppear(animated: Bool) {

    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBarHidden = false
        
        var titleLabel = AppUtil.getThemeTitleLabelWithWidth(self.view.frame.width)
        titleLabel.text = "Utah Lots of Lots"
        self.navigationItem.titleView = titleLabel
    }
    
    
    
    //DropDownMenuViewDelegate methods
    func menuExpanded(sender: DropDownMenuView) {
        switch(sender)
        {
        case _allLotsElement!:
            _aLotsElement?.retractMenu()
            _eLotsElement?.retractMenu()
            _uLotsElement?.retractMenu()
        case _aLotsElement!:
            _allLotsElement?.retractMenu()
            _eLotsElement?.retractMenu()
            _uLotsElement?.retractMenu()
            print("a")
        case _eLotsElement!:
            _aLotsElement?.retractMenu()
            _allLotsElement?.retractMenu()
            _uLotsElement?.retractMenu()
            print("e")
        case _uLotsElement!:
            _aLotsElement?.retractMenu()
            _eLotsElement?.retractMenu()
            _allLotsElement?.retractMenu()
            print("u")
        default:
            print("")
        }
        setButtonFramesAfterMenusChanged()
    }
    
    func menuRetracted(sender: DropDownMenuView) {
        switch(sender)
        {
        case _allLotsElement!:
            
            print("all")
        case _aLotsElement!:
            print("a")
        case _eLotsElement!:
            print("e")
        case _uLotsElement!:
            print("u")
        default:
            print("")
        }
        setButtonFramesAfterMenusChanged()
    }
    
    func secondaryButtonPressed(sender: DropDownMenuView, button: LotData.SecondaryButtonTag) {
        var primaryLotTag: LotData.PrimaryLotTag?
        var secondaryLotTag: LotData.SecondaryButtonTag?
        var tableCellButtonColor: UIColor!
        switch(sender)
        {
        case _allLotsElement!:
            tableCellButtonColor = _allLotsElement?.color
            primaryLotTag = LotData.PrimaryLotTag.allLot
        case _aLotsElement!:
                tableCellButtonColor = _aLotsElement?.color
            primaryLotTag = LotData.PrimaryLotTag.aLot
        case _eLotsElement!:
            tableCellButtonColor = _eLotsElement?.color
            primaryLotTag = LotData.PrimaryLotTag.eLot
        case _uLotsElement!:
            tableCellButtonColor = _uLotsElement?.color
            primaryLotTag = LotData.PrimaryLotTag.uLot
        default:
            tableCellButtonColor = UIColor.grayColor()
            print("Unsupported tag type")
        }
        
        secondaryLotTag = button
        
        var lotsTable = LotsTable(primaryLotType: primaryLotTag!,
                                secondaryLotType: secondaryLotTag!,
                                locationTracker: locationTracker!,
                                cellColor: tableCellButtonColor)

        navigationController?.pushViewController(lotsTable, animated: false)
    }
    
    
    
    //LocationTrackerDelegate methods
    func trackedRegionLeft(region: CLRegion) {
        var currentTime: NSTimeInterval = NSDate().timeIntervalSince1970
        LotsManager.markLotAsLeft(region.identifier, time: currentTime)
    }
    
    
    
    func trackedRegionVisited(region: CLRegion) {
        var currentTime: NSTimeInterval = NSDate().timeIntervalSince1970
        LotsManager.markLotAsParked(region.identifier, time: currentTime)
    }
    
}
