//
//  UserModel.swift
//  FinalProjectUtahLOL
//
//  Created by Nite Out on 4/8/15.
//  Copyright (c) 2015 Mike. All rights reserved.
//

import Parse

class UserModel: NSObject {
    
    // [lotId:timestamp]
    var recentParkedLots: [String:UInt] = [String: UInt]()
    var recentLeftLots: [String:UInt]   = [String: UInt]()
    
    var userName: String!
    {
            return PFUser.currentUser().username
    }
    
    var userEmail: String!
    {
            return PFUser.currentUser().email
    }
    
    
    
    class func signUpUserWithName(name: String, email: String, password: String, completion: (succeeded: Bool!, error: NSError!) -> Void)
    {
        var user = PFUser()
        user.username = name
        user.email    = email
        user.password = password
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            
            completion(succeeded: succeeded, error: error)
        }
    }
    
    
    
    class func logInUserWithName(name: String, password: String, completion: (user: PFUser!, error: NSError!) -> Void)
    {
        PFUser.logInWithUsernameInBackground(name, password:password) {
            (user: PFUser!, error: NSError!) -> Void in
            
            completion(user: user, error: error)
        }
    }
}
