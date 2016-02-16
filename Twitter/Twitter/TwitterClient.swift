//
//  TwitterClient.swift
//  Twitter
//
//  Created by Adam Epstein on 2/15/16.
//  Copyright © 2016 Adam Epstein. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

let twitterConsumerKey = "UouyomFLPkK1VsGbvfjXTXbnP"
let twitterConsumerSecret = "QkERtLtFj7Y346zgnhR3VkUWX8ieIsJfOla12Bf4iHZYK9OK2Q"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")
    
class TwitterClient: BDBOAuth1SessionManager {
        
        class var sharedInstance: TwitterClient {
            struct Static {
                static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
            }
            
            return Static.instance
            
        }


}
