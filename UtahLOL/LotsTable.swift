//
//  LotsTable.swift
//  FinalProjectUtahLOL
//
//  Created by Nite Out on 4/13/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit

class LotsTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var _lotsTableView: UITableView?
    private var _primaryLotType: LotData.PrimaryLotTag?
    private var _secondaryLotType: LotData.SecondaryButtonTag?
    private var _locationTracker: LocationTracker?
    private var _lots: [LotData] = []
    
    private var _currOffset: Int = 0
    private let _lotsLimit: Int  = 15
    
    init(primaryLotType: LotData.PrimaryLotTag, secondaryLotType: LotData.SecondaryButtonTag, locationTracker: LocationTracker)
    {
        super.init()
        
        _locationTracker = locationTracker
        
        var titleString: String = ""
        
        switch(secondaryLotType)
        {
            case .AnyButton:
                titleString += "Any"
            case .EmptiestButton:
                titleString += "Emptiest"
            case .NearestButton:
                titleString += "Nearest"
            default:
                titleString += ""
        }
        
        switch(primaryLotType)
        {
            case .aLot:
                titleString += " A Lots"
            case .uLot:
                titleString += " U Lots"
            case .eLot:
                titleString += " E Lots"
            default:
                titleString += " Lots"
        }
        
        self.title = titleString
        _primaryLotType   = primaryLotType
        _secondaryLotType = secondaryLotType
    }
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    
    override func viewDidLoad() {
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        _lotsTableView = UITableView(frame: view.frame)
        _lotsTableView?.delegate   = self
        _lotsTableView?.dataSource = self
        
        view.addSubview(_lotsTableView!)
        
        if _secondaryLotType == LotData.SecondaryButtonTag.AnyButton
        {
            LotsManager.getAllLotsOfType(_primaryLotType!, offset: _currOffset, number: _lotsLimit) { (lots) -> Void in
                self._lots = lots
                dispatch_async(dispatch_get_main_queue(),{
                    self._lotsTableView?.reloadData()
                    return
                })
            }
        }
        else if _secondaryLotType == LotData.SecondaryButtonTag.EmptiestButton
        {
            LotsManager.getEmptiestLotsOfType(_primaryLotType!, offset: _currOffset, number: _lotsLimit, completion: { (lots) -> Void in
                self._lots = lots
                dispatch_async(dispatch_get_main_queue(),{
                    self._lotsTableView?.reloadData()
                    return
                })
            })
        }
        else if _secondaryLotType == LotData.SecondaryButtonTag.NearestButton
        {
            LotsManager.getNearestLotsOfType(_primaryLotType!, location: _locationTracker!.latestLocation, offset: _currOffset, number: _lotsLimit, completion: { (lots) -> Void in
                self._lots = lots
                dispatch_async(dispatch_get_main_queue(),{
                    self._lotsTableView?.reloadData()
                    return
                })
            })
        }
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    
    
    //tableView delegates
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: LotsTableViewCell? = (tableView.dequeueReusableCellWithIdentifier("Cell") as LotsTableViewCell?)
        
        if( cell == nil )
        {
            cell = LotsTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        var lotObject: LotData = _lots[indexPath.row]
        
        cell?.nameLabel?.text    = lotObject.name
        cell?.addressLabel?.text = lotObject.address
        return cell!
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return _lotsTableView!.frame.height / 4.0
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _lots.count
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
