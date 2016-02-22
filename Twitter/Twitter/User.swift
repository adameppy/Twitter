//
//  User.swift
//  Twitter
//
//  Created by Adam Epstein on 2/16/16.
//  Copyright © 2016 Adam Epstein. All rights reserved.
//

import UIKit


class User: NSObject {

    var name: String?
    var screenname: String?
    var imageURL: String?
    var tagline: String?
    var dictionary: NSDictionary
    var profileURL: NSURL?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary as NSDictionary
        name = dictionary["name"] as? String
        screenname = "@\(dictionary["screen_name"]!)" as? String
        imageURL = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = NSURL(string: profileURLString)
            //print(profileURLString)
        }
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil{
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
        
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else{
                defaults.setObject(nil, forKey: "currentUserData")

            }
            
            defaults.synchronize()

        }
    }
}
