//
//  LOLHomeViewController.swift
//  FinalProjectUtahLOL
//
//  Created by Nite Out on 4/8/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit

class LOLHomeViewController: UIViewController, DropDownMenuViewDelegate {
    
    private var _allLotsElement: DropDownMenuView?
    private var _aLotsElement: DropDownMenuView?
    private var _eLotsElement: DropDownMenuView?
    private var _uLotsElement: DropDownMenuView?
    
    //vertical margin between buttons
    private var vMargin: CGFloat = 0.0
    private var secondaryButtonHeight: CGFloat = 0.0
    private var primaryButtonHeight: CGFloat   = 0.0
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        vMargin               = self.view.frame.height / 36.0
        primaryButtonHeight   = self.view.frame.height / 8.0
        secondaryButtonHeight = self.view.frame.height / 16.0
        
        
        var cursor: CGPoint = CGPointMake(view.frame.origin.x, view.frame.origin.y + self.view.frame.height / 16.0)
        
        var allLotsFrame = CGRectMake(cursor.x, cursor.y, self.view.frame.width, primaryButtonHeight)
        
        let eLotsColor = UIColor(red:65.0/255.0, green: 147.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        
        _allLotsElement = DropDownMenuView(frame: allLotsFrame,
            color: UIColor.orangeColor(),
            name: "All",
            secondaryButtonHeight: secondaryButtonHeight)
        _allLotsElement?.delegate = self
        cursor.y += allLotsFrame.height + vMargin
        
        var aLotsFrame = CGRectMake(cursor.x, cursor.y, self.view.frame.width, primaryButtonHeight)
        
        _aLotsElement = DropDownMenuView(frame:aLotsFrame,
            color: UIColor.brownColor(),
            name: "A Lots",
            secondaryButtonHeight: secondaryButtonHeight)
        _aLotsElement?.delegate = self
        
        cursor.y += aLotsFrame.height + vMargin
        
        var eLotsFrame = CGRectMake(cursor.x, cursor.y, self.view.frame.width, primaryButtonHeight)
        
        _eLotsElement = DropDownMenuView(frame:eLotsFrame,
            color: eLotsColor,
            name: "E Lots",
            secondaryButtonHeight: secondaryButtonHeight)
        _eLotsElement?.delegate = self
        
        cursor.y += eLotsFrame.height + vMargin
        
        var uLotsFrame = CGRectMake(cursor.x, cursor.y, self.view.frame.width, primaryButtonHeight)
        
        _uLotsElement = DropDownMenuView(frame:uLotsFrame,
            color: UIColor.redColor(),
            name: "U Lots",
            secondaryButtonHeight: secondaryButtonHeight)
        _uLotsElement?.delegate = self
        
        view.addSubview(_allLotsElement!)
        view.addSubview(_aLotsElement!)
        view.addSubview(_eLotsElement!)
        view.addSubview(_uLotsElement!)
    }
    
    
    
    func setButtonFramesAfterMenusChanged()
    {
        var cursor: CGPoint = CGPointMake(view.frame.origin.x, view.frame.origin.y + self.view.frame.height / 16.0)
        
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
    
    
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
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
        switch(sender)
        {
        case _allLotsElement!:
            primaryLotTag = LotData.PrimaryLotTag.allLot
        case _aLotsElement!:
            primaryLotTag = LotData.PrimaryLotTag.aLot
        case _eLotsElement!:
            primaryLotTag = LotData.PrimaryLotTag.eLot
        case _uLotsElement!:
            primaryLotTag = LotData.PrimaryLotTag.uLot
        default:
            print("Unsupported tag type")
        }
        
        secondaryLotTag = button
        
        var lotsTable = LotsTable(primaryLotType: primaryLotTag!, secondaryLotType: secondaryLotTag!)
        
        navigationController?.pushViewController(lotsTable, animated: false)
    }
}
