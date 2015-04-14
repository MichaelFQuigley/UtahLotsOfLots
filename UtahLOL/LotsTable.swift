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
    
    private var _lots: [LotData] = []
    
    private var _currOffset: Int = 0
    private let _lotsLimit: Int  = 15
    
    init(primaryLotType: LotData.PrimaryLotTag, secondaryLotType: LotData.SecondaryButtonTag)
    {
        super.init()
        
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
        
        LotsManager.getAllLotsOfType(_primaryLotType!, secondaryType: _secondaryLotType!, offset: _currOffset, number: _lotsLimit) { (lots) -> Void in
            self._lots = lots
            dispatch_async(dispatch_get_main_queue(),{
                self._lotsTableView?.reloadData()
                return
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
        
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return _lotsTableView!.frame.height / 4.0
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _lots.count
    }
    
}
