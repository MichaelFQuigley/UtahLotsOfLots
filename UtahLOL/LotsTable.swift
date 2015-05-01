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
    private var _loadingView: LoadingView?
    private var _primaryLotType: LotData.PrimaryLotTag?
    private var _secondaryLotType: LotData.SecondaryButtonTag?
    private var _locationTracker: LocationTracker?
    private var _lots: [LotData] = []
    private var _tableCellColor: UIColor!
    
    private var _currOffset: Int = 0
    private let _lotsLimit: Int  = 15
    
    private var _lastUpdatedTime: Double = 0.0
    var titleString: String = ""
    
    private var _refreshTimer: NSTimer?
    private var _refreshTimerInterval_sec: Double = 60.0
    
    init(primaryLotType: LotData.PrimaryLotTag, secondaryLotType: LotData.SecondaryButtonTag, locationTracker: LocationTracker, cellColor: UIColor)
    {
        super.init()
        
        _lastUpdatedTime = NSDate().timeIntervalSince1970
        
        _tableCellColor = cellColor
        
        _locationTracker = locationTracker
        
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
    
    
    
    func refreshLots()
    {
        showLoadingView(true)
        loadLots()
    }
    
    
    
    func startRefreshTimer()
    {
        self._refreshTimer = NSTimer(timeInterval: self._refreshTimerInterval_sec,
            target: self,
            selector: "refreshLots",
            userInfo: nil,
            repeats: true)
        
        NSRunLoop.currentRunLoop().addTimer(self._refreshTimer!, forMode: NSDefaultRunLoopMode)
    }
    
    
    
    func loadLots()
    {
        if _secondaryLotType == LotData.SecondaryButtonTag.AnyButton
        {
            LotsManager.getAllLotsOfType(_primaryLotType!, offset: _currOffset, number: _lotsLimit) { (lots) -> Void in
                self._lots = lots
                dispatch_async(dispatch_get_main_queue(),{
                    self.showLoadingView(false)
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
                    self.showLoadingView(false)
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
                    self.showLoadingView(false)
                    self._lotsTableView?.reloadData()
                    return
                })
            })
        }
    }
    
    
    
    override func viewDidLoad() {
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.view.backgroundColor = AppUtil.themeColor
        
        _loadingView = LoadingView(frame: view.frame)
        var lotsFrame : CGRect = CGRectMake(view.frame.origin.x,
            view.frame.origin.y,
            view.frame.width,
            view.frame.height - self.navigationController!.navigationBar.frame.size.height - 20.0)
        _lotsTableView = UITableView(frame: lotsFrame)
        _lotsTableView?.separatorStyle  = UITableViewCellSeparatorStyle.None
        _lotsTableView?.delegate        = self
        _lotsTableView?.dataSource      = self
        _lotsTableView?.backgroundColor = AppUtil.themeColor
        
        self.showLoadingView(true)
        
        view.addSubview(_loadingView!)
        view.addSubview(_lotsTableView!)
        
        loadLots()
        startRefreshTimer()
    }
    
    
    
    func showLoadingView(yes: Bool)
    {
        if yes
        {
            self._loadingView?.hidden   = false
            self._lotsTableView?.hidden = true
        }
        else
        {
            self._loadingView?.hidden   = true
            self._lotsTableView?.hidden = false
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.edgesForExtendedLayout = UIRectEdge.None
        
        var titleLabel = AppUtil.getThemeTitleLabelWithWidth(self.view.frame.width)
        titleLabel.text = titleString
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }
    

    
    //tableView delegates
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: LotsTableViewCell? = (tableView.dequeueReusableCellWithIdentifier("Cell") as LotsTableViewCell?)
        
        if( cell == nil )
        {
            cell = LotsTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell", gradientColor: _tableCellColor)
        }
        
        var lotObject: LotData = _lots[indexPath.row]
        
        cell?.nameLabel?.text    = lotObject.name
        cell?.addressLabel?.text = lotObject.address
        cell?.statusLabel?.text  =  lotObject.confidenceLevelStr + " " + lotObject.getTrafficLevelStr(_lastUpdatedTime)
        
        return cell!
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        var mapVC: LotMapViewController = LotMapViewController(lot: _lots[indexPath.row], locationTracker: _locationTracker!)
        
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return _lotsTableView!.frame.height / 4.0
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _lots.count
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    
        if self.isMovingFromParentViewController() || self.isBeingDismissed()
        {
            self._refreshTimer?.invalidate()
        }
    }
}
