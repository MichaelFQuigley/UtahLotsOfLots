//
//  DropDownMenuView.swift
//  FinalProjectUtahLOL
//
//  Created by Nite Out on 4/8/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit

protocol DropDownMenuViewDelegate: class
{
    func menuExpanded(sender: DropDownMenuView)
    func menuRetracted(sender: DropDownMenuView)
    
    func secondaryButtonPressed(sender: DropDownMenuView, button: LotData.SecondaryButtonTag)
}



class DropDownMenuView: UIView {
    weak var delegate: DropDownMenuViewDelegate? = nil
    private var _color: UIColor                 = UIColor.whiteColor()
    private var _name: String                   = ""
    private var _primaryButton: UIButton        = UIButton()
    private var secondaryButtons: [UIButton]    = []
    private var _primaryButtonHeight: CGFloat   = 0.0
    private var _secondaryButtonHeight: CGFloat = 0.0
    private var _droppedDown: Bool              = false
    private var _secondaryButtonColor: UIColor  = UIColor.grayColor()
    
    
    
    init(frame: CGRect, color: UIColor, name: String, secondaryButtonHeight: CGFloat)
    {
        super.init(frame: frame)
        self.frame             = frame
        _primaryButtonHeight   = frame.height
        _secondaryButtonHeight = secondaryButtonHeight
        _color                 = color
        _name                  = name
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    var droppedDown: Bool{return _droppedDown}
    
    
    
    var secondaryButtonsColor: UIColor
    {
        get{return _secondaryButtonColor}
        set
        {
            _secondaryButtonColor = newValue
        }
    }
    
    
    
    var color: UIColor
    {
        return _color
    }
    
    
    
    var primaryButtonTitleColor: UIColor
        {
        get{
            return _primaryButton.titleColorForState(UIControlState.Normal)!
        }
        set{
            _primaryButton.setTitleColor(newValue, forState: UIControlState.Normal)
        }
    }
    
    
    
    override func layoutSubviews() {
        
        var cursor: CGPoint = CGPointMake(0, 0)
        
        self.layer.shadowColor   = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 4.0;
        self.layer.shadowRadius  = 4.0;
        self.layer.shadowOffset  = CGSizeMake(4.0, 4.0)
        
        _primaryButton.frame           = CGRectMake(cursor.x,
            cursor.y,
            frame.width,
            _primaryButtonHeight)
        _primaryButton.backgroundColor = _color
        _primaryButton.setTitle(_name, forState: UIControlState.Normal)
        _primaryButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        _primaryButton.titleLabel?.font = UIFont(name: AppUtil.themeFont, size: 32.0)
        _primaryButton.addTarget(self, action: "primaryButtonPressed", forControlEvents: UIControlEvents.TouchDown)
        _primaryButton.layer.borderWidth   = 3.0
        _primaryButton.layer.borderColor   = UIColor.grayColor().CGColor
        _primaryButton.layer.cornerRadius  = 8.0
        _primaryButton.layer.masksToBounds = true
        
        var imageViewDim: CGFloat = min(_primaryButton.frame.height, 40.0)
        
        _primaryButton.setImage(ImageUtil.imageWithName("right-arrow-512.png", size: CGSizeMake(imageViewDim, imageViewDim)), forState: UIControlState.Normal)
        _primaryButton.imageView?.frame  = CGRectMake(_primaryButton.frame.width - imageViewDim,
            (_primaryButton.frame.height - imageViewDim) / 2.0,
            imageViewDim,
            imageViewDim)
        
        cursor.y += _primaryButton.frame.height
        
        let leftMargin: CGFloat = 12.0
        
        for var i = 0; i < LotData.SecondaryButtonTag.numSecButtons.rawValue; i++
        {
            var tempButton = UIButton()
            tempButton.frame = CGRectMake(cursor.x + leftMargin, cursor.y, frame.width - leftMargin, _secondaryButtonHeight)
            tempButton.backgroundColor     = _secondaryButtonColor
            tempButton.layer.borderWidth   = 3.0
            tempButton.layer.borderColor   = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).CGColor
            tempButton.layer.cornerRadius  = 8.0
            tempButton.layer.masksToBounds = true
            tempButton.hidden              = true
            tempButton.titleLabel?.font    = UIFont(name: AppUtil.themeFont, size: 20.0)
            tempButton.addTarget(self, action: "secondaryButtonPressed:", forControlEvents: UIControlEvents.TouchDown)
            
            cursor.y += tempButton.frame.height
            
            secondaryButtons.append(tempButton)
        }
        
        //   self.frame.height = cursor.y
        
        secondaryButtons[LotData.SecondaryButtonTag.AnyButton.rawValue].tag = LotData.SecondaryButtonTag.AnyButton.rawValue
        secondaryButtons[LotData.SecondaryButtonTag.AnyButton.rawValue].setTitle("Any", forState: UIControlState.Normal)
        addSubview(secondaryButtons[LotData.SecondaryButtonTag.AnyButton.rawValue])
        
        secondaryButtons[LotData.SecondaryButtonTag.NearestButton.rawValue].tag = LotData.SecondaryButtonTag.NearestButton.rawValue
        secondaryButtons[LotData.SecondaryButtonTag.NearestButton.rawValue].setTitle("Nearest", forState: UIControlState.Normal)
        addSubview(secondaryButtons[LotData.SecondaryButtonTag.NearestButton.rawValue])
        
        secondaryButtons[LotData.SecondaryButtonTag.EmptiestButton.rawValue].tag = LotData.SecondaryButtonTag.EmptiestButton.rawValue
        secondaryButtons[LotData.SecondaryButtonTag.EmptiestButton.rawValue].setTitle("Emptiest", forState: UIControlState.Normal)
        addSubview(secondaryButtons[LotData.SecondaryButtonTag.EmptiestButton.rawValue])
        
        addSubview(_primaryButton)
    }
    
    
    
    func secondaryButtonPressed(sender: UIButton)
    {
        switch(sender.tag)
        {
        case LotData.SecondaryButtonTag.AnyButton.rawValue:
            delegate?.secondaryButtonPressed(self, button: LotData.SecondaryButtonTag.AnyButton)
        case LotData.SecondaryButtonTag.EmptiestButton.rawValue:
            delegate?.secondaryButtonPressed(self, button: LotData.SecondaryButtonTag.EmptiestButton)
        case LotData.SecondaryButtonTag.NearestButton.rawValue:
            delegate?.secondaryButtonPressed(self, button: LotData.SecondaryButtonTag.NearestButton)
        default:
            print("No button for tag")
        }
    }
    
    
    
    func retractMenu()
    {
        var imageViewDim: CGFloat = min(_primaryButton.frame.height, 40.0)
        var rightArrow = ImageUtil.imageWithName("right-arrow-512.png", size: CGSizeMake(imageViewDim, imageViewDim))
        _primaryButton.setImage(rightArrow, forState: UIControlState.Normal)
        for var i = 0; i < LotData.SecondaryButtonTag.numSecButtons.rawValue; i++
        {
            secondaryButtons[i].hidden = true
        }
        
        self.frame = CGRectMake(frame.origin.x,
            frame.origin.y,
            frame.width,
            _primaryButtonHeight)
        _droppedDown = false
    }
    
    
    
    func expandMenu()
    {
        var imageViewDim: CGFloat = min(_primaryButton.frame.height, 40.0)
        var rightArrow            = ImageUtil.imageWithName("right-arrow-512.png", size: CGSizeMake(imageViewDim, imageViewDim))
        var downArrow             = UIImage(CGImage: rightArrow.CGImage, scale: 1.0, orientation: UIImageOrientation.Right)
        
        _primaryButton.setImage(downArrow, forState: UIControlState.Normal)
        
        for var i = 0; i < LotData.SecondaryButtonTag.numSecButtons.rawValue; i++
        {
            secondaryButtons[i].hidden = false
        }
        
        self.frame = CGRectMake(frame.origin.x,
            frame.origin.y,
            frame.width,
            _primaryButtonHeight + _secondaryButtonHeight * CGFloat(LotData.SecondaryButtonTag.numSecButtons.rawValue))
        _primaryButton.imageView?.frame  = CGRectMake(_primaryButton.frame.width - imageViewDim,
            (_primaryButton.frame.height - imageViewDim) / 2.0,
            imageViewDim,
            imageViewDim)
        _droppedDown = true
    }
    
    
    
    func primaryButtonPressed()
    {
        _droppedDown = !_droppedDown
        

        if _droppedDown
        {
            expandMenu()
            delegate?.menuExpanded(self)
        }
        else
        {
            retractMenu()
            delegate?.menuRetracted(self)
        }
    }
}
