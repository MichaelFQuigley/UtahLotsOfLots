//
//  ViewController.swift
//  FinalProjectUtahLOL
//
//  Created by Nite Out on 4/8/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import UIKit
import Parse

class LogInPage: UIViewController, UITextFieldDelegate, SignUpPageDelegate {
    
    private var _scrollView:    UIScrollView?
    private var _logInLabel:    UILabel?
    private var _logInButton:   UIButton?
    private var _signUpButton:  UIButton?
    private var _userNameField: UITextField?
    private var _passNameField: UITextField?
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
        
        _logInLabel = UILabel(frame: CGRectMake(cursor.x,
            cursor.y,
            self._scrollView!.frame.width,
            fieldHeight))
        _logInLabel?.text          = "Log In"
        _logInLabel?.textAlignment = NSTextAlignment.Center
        cursor.y += _logInLabel!.frame.height + vMargin
        
        _userNameField = UITextField(frame: CGRectMake(cursor.x + hMargin,
            cursor.y,
            self._scrollView!.frame.width - 2.0 * hMargin,
            fieldHeight))
        _userNameField?.placeholder        = " User Name"
        _userNameField?.backgroundColor    = UIColor.whiteColor()
        _userNameField?.layer.cornerRadius = 8.0
        _userNameField?.delegate           = self
        
        cursor.y += _userNameField!.frame.height + vMargin
        
        _passNameField = UITextField(frame: CGRectMake(cursor.x + hMargin,
            cursor.y,
            self._scrollView!.frame.width - 2.0 * hMargin,
            fieldHeight))
        _passNameField?.placeholder        = " Password"
        _passNameField?.backgroundColor    = UIColor.whiteColor()
        _passNameField?.layer.cornerRadius = 8.0
        _passNameField?.delegate           = self
        
        cursor.y += _passNameField!.frame.height + vMargin
        
        _logInButton = UIButton(frame: CGRectMake(cursor.x + hMargin,
            cursor.y,
            self._scrollView!.frame.width - 2.0 * hMargin,
            fieldHeight))
        _logInButton?.setTitle("Log In", forState: UIControlState.Normal)
        _logInButton?.backgroundColor    = UIColor.lightGrayColor()
        _logInButton?.layer.cornerRadius = 12.0
        _logInButton?.addTarget(self, action: "logInButtonPressed", forControlEvents: UIControlEvents.TouchDown)
        
        cursor.y += _logInButton!.frame.height + vMargin
        
        _signUpButton = UIButton(frame: CGRectMake(cursor.x + hMargin,
            cursor.y,
            self._scrollView!.frame.width - 2.0 * hMargin,
            fieldHeight))
        _signUpButton?.setTitle("Sign Up", forState: UIControlState.Normal)
        _signUpButton?.backgroundColor    = UIColor.greenColor()
        _signUpButton?.layer.cornerRadius = 12.0
        _signUpButton?.addTarget(self, action: "signUpButtonPressed", forControlEvents: UIControlEvents.TouchDown)
        
        
        _scrollView?.addSubview(_logInLabel!)
        _scrollView?.addSubview(_userNameField!)
        _scrollView?.addSubview(_passNameField!)
        _scrollView?.addSubview(_logInButton!)
        _scrollView?.addSubview(_signUpButton!)
        view.addSubview(_scrollView!)
        view.addSubview(_loadingView!)
        
        if (PFUser.currentUser() != nil)
        {
            self.navigationController?.pushViewController(LOLHomeViewController(), animated: true)
        }
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
        /*
        if (PFUser.currentUser() != nil)
        {
        _loadingView?.hidden = false
        }
        else
        {
        _loadingView?.hidden = true
        }*/
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
    func logInButtonPressed()
    {
        if !(_userNameField!.text.isEmpty || _passNameField!.text.isEmpty)
        {
            _loadingView?.hidden = false
            _userNameField?.resignFirstResponder()
            _passNameField?.resignFirstResponder()
            
            UserModel.logInUserWithName(_userNameField!.text, password: _passNameField!.text, completion: { (user, error) -> Void in
                
                if error == nil {
                    self.navigationController?.pushViewController(LOLHomeViewController(), animated: true)
                    self._loadingView?.hidden = true
                } else {
                    let errorString = error.userInfo!["error"] as NSString
                    var alertView: UIAlertView = UIAlertView(title: "Error", message: errorString, delegate: nil, cancelButtonTitle: "Ok")
                    self._loadingView?.hidden = true
                    alertView.show()
                }
            })
        }
    }
    
    
    
    func signUpButtonPressed()
    {
        var svc = SignUpPage()
        svc.delegate = self
        presentViewController(svc, animated: true, completion: nil)
    }
    
    
    
    //SignUpPageDelegate methods
    func didSignUp() {
        dismissViewControllerAnimated(false, completion: nil)
        self.navigationController?.pushViewController(LOLHomeViewController(), animated: true)
    }
    
    
    
    func signUpCancelled() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

