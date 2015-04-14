//
//  SignUpPage.swift
//  FinalProjectUtahLOL
//
//  Created by Nite Out on 4/8/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit
import Parse



protocol SignUpPageDelegate: class
{
    func didSignUp()
    func signUpCancelled()
}



class SignUpPage: UIViewController, UITextFieldDelegate {
    
    weak var delegate: SignUpPageDelegate? = nil
    private var _scrollView:    UIScrollView?
    private var _signUpLabel:    UILabel?
    private var _signUpButton:  UIButton?
    private var _userNameField: UITextField?
    private var _passNameField: UITextField?
    private var _emailField: UITextField?
    private var _cancelButton: UIButton?
    private var _loadingView: LoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.grayColor()
        
        let fieldHeight:  CGFloat = self.view.frame.height / 12.0
        let vMargin:      CGFloat = self.view.frame.height / 32.0
        let hMargin:      CGFloat = self.view.frame.width  / 32.0
        
        _loadingView = LoadingView(frame: view.frame)
        _loadingView?.hidden = true
        
        _scrollView = UIScrollView(frame: view.frame)
        _scrollView?.contentSize = CGSizeMake(view.frame.width, view.frame.height * 1.4)
        
        var cursor: CGPoint      = CGPointMake(_scrollView!.frame.origin.x,
            _scrollView!.frame.origin.y + _scrollView!.frame.height / 6.0)
        
        _signUpLabel = UILabel(frame: CGRectMake(cursor.x,
            cursor.y,
            self._scrollView!.frame.width,
            fieldHeight))
        _signUpLabel?.text          = "Sign Up"
        _signUpLabel?.textAlignment = NSTextAlignment.Center
        cursor.y += _signUpLabel!.frame.height + vMargin
        
        _userNameField = UITextField(frame: CGRectMake(cursor.x + hMargin,
            cursor.y,
            self._scrollView!.frame.width - 2.0 * hMargin,
            fieldHeight))
        _userNameField?.placeholder        = " User Name"
        _userNameField?.backgroundColor    = UIColor.whiteColor()
        _userNameField?.layer.cornerRadius = 8.0
        _userNameField?.delegate           = self
        
        cursor.y += _userNameField!.frame.height + vMargin
        
        _emailField = UITextField(frame: CGRectMake(cursor.x + hMargin,
            cursor.y,
            self._scrollView!.frame.width - 2.0 * hMargin,
            fieldHeight))
        _emailField?.placeholder        = " Email"
        _emailField?.backgroundColor    = UIColor.whiteColor()
        _emailField?.layer.cornerRadius = 8.0
        _emailField?.delegate           = self
        
        cursor.y += _emailField!.frame.height + vMargin
        
        _passNameField = UITextField(frame: CGRectMake(cursor.x + hMargin,
            cursor.y,
            self._scrollView!.frame.width - 2.0 * hMargin,
            fieldHeight))
        _passNameField?.placeholder        = " Password"
        _passNameField?.backgroundColor    = UIColor.whiteColor()
        _passNameField?.layer.cornerRadius = 8.0
        _passNameField?.delegate           = self
        
        cursor.y += _passNameField!.frame.height + vMargin
        
        _signUpButton = UIButton(frame: CGRectMake(cursor.x + hMargin,
            cursor.y,
            self._scrollView!.frame.width - 2.0 * hMargin,
            fieldHeight))
        _signUpButton?.setTitle("Sign Up", forState: UIControlState.Normal)
        _signUpButton?.backgroundColor    = UIColor.greenColor()
        _signUpButton?.layer.cornerRadius = 12.0
        _signUpButton?.addTarget(self, action: "signUpButtonPressed", forControlEvents: UIControlEvents.TouchDown)
        
        cursor.y += _signUpButton!.frame.height + vMargin
        
        _cancelButton = UIButton(frame: CGRectMake(cursor.x + 2.0 * hMargin,
            cursor.y,
            self._scrollView!.frame.width - 4.0 * hMargin,
            fieldHeight))
        _cancelButton?.setTitle("Cancel", forState: UIControlState.Normal)
        _cancelButton?.backgroundColor    = UIColor.lightGrayColor()
        _cancelButton?.layer.cornerRadius = 12.0
        _cancelButton?.addTarget(self, action: "cancelButtonPressed", forControlEvents: UIControlEvents.TouchDown)
        
        _scrollView?.addSubview(_signUpLabel!)
        _scrollView?.addSubview(_userNameField!)
        _scrollView?.addSubview(_emailField!)
        _scrollView?.addSubview(_passNameField!)
        _scrollView?.addSubview(_signUpButton!)
        _scrollView?.addSubview(_cancelButton!)
        view.addSubview(_scrollView!)
        view.addSubview(_loadingView!)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    //button targets
    func signUpButtonPressed()
    {
        if !(_userNameField!.text.isEmpty || _emailField!.text.isEmpty || _passNameField!.text.isEmpty)
        {
            _loadingView?.hidden = false
            _userNameField?.resignFirstResponder()
            _passNameField?.resignFirstResponder()
            _emailField?.resignFirstResponder()
            
            UserModel.signUpUserWithName(_userNameField!.text, email: _emailField!.text, password: _passNameField!.text) { (succeeded, error) -> Void in
                if error == nil {
                    self.delegate?.didSignUp()
                } else {
                    let errorString = error.userInfo!["error"] as NSString
                    var alertView: UIAlertView = UIAlertView(title: "Error", message: errorString, delegate: nil, cancelButtonTitle: "Ok")
                    self._loadingView?.hidden = true
                    alertView.show()
                }
            }
        }
    }
    
    
    
    func cancelButtonPressed()
    {
        delegate?.signUpCancelled()
    }
    
}

