//
//  VelocityQueue.swift
//  UtahLOL
//
//  Created by Nite Out on 4/15/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit

class VelocityQueue<T>: NSObject {
    
    private var _velocityQueue: [T]!
    private let _velocityQueueMaxSize: UInt
    
    init(maxSize: UInt)
    {
        _velocityQueueMaxSize = maxSize
        super.init()
        
        _velocityQueue = [T]()
    }
    
    private init(maxSize: UInt, vItems: [T])
    {
        _velocityQueueMaxSize = maxSize
        super.init()
        
        _velocityQueue = vItems
    }
    
    
    var count: Int{return _velocityQueue.count}
    
    var items: [T] {return _velocityQueue}
    
    func enqueue(item: T)
    {
        if UInt(_velocityQueue.count) >= _velocityQueueMaxSize
        {
            _velocityQueue.removeAtIndex(0)
        }
        
        _velocityQueue.append(item)
    }
    
    func dequeue() -> T?
    {
        if _velocityQueue.count == 0
        {
            return nil
        }
        
        return _velocityQueue.removeAtIndex(0)
    }
    
    
    //example: if function is ((item: T) -> Void in {item < 7}), then this function will return the number of items in the queue less than 7
    func numItemsRelativeToOperator(operatorFunc: (item: T) -> Bool) -> UInt
    {
        var numItems:UInt = 0
        
        for item in _velocityQueue
        {
            if operatorFunc(item: item)
            {
                numItems++
            }
        }
        return numItems
    }
    
    
    
    func vCopy() -> VelocityQueue {
        return VelocityQueue(maxSize: _velocityQueueMaxSize, vItems: Array(self.items[0..<self.items.count]))
    }
}
