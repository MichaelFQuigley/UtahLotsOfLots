//
//  LotData.swift
//  FinalProjectUtahLOL
//
//  Created by Nite Out on 4/14/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit
import CoreLocation

class LotData: NSObject {
    
    var name: String?
    var address: String?
    var lotId: String?
    var lotStatus: LotStatus?
    var lotTypeFlags: Int = 0
    var parkedTimes: [UInt] = []
    var leftTimes:   [UInt] = []
    var lotRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
                                                        radius: 0.0,
                                                        identifier: "")
    enum PrimaryLotTag: Int
    {
        case aLot = 1, eLot = 2, allLot = 4, uLot = 8
    }
    
    enum SecondaryButtonTag: Int{
        case AnyButton = 0, NearestButton, EmptiestButton, numSecButtons
    }
    
    enum LotStatus: Int
    {
        case Unknown = 0, Empty, Moderate, Busy, Packed
    }
    
    override init() {
        super.init()
    }
}
