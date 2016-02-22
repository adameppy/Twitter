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
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
        
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
            
        return Static.instance
            
    }
    
    func loginWithCompletion(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        //fetch request token + redirect to authorization page
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterAdam://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginFailure?(error)
               
                
        }
    }
    
    func openURL(url: NSURL){
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
    
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success:         { (accesstoken:BDBOAuth1Credential!) -> Void in
            print("Got the access token")
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error)
            })
            
            
            
    
            }) { (error: NSError!) -> Void in
                print("Failed to recieve access token")
                self.loginFailure?(error)

        }
    
    }
    
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()){
        
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            var tweets = Tweet.TweetsWithArray(response as! [NSDictionary])
            for tweet in tweets{
                print("tweet: \(tweet.text)")
            }
            success(tweets)
            //print("user: \(response)")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting home timeline")
                print(error)
                failure(error)
        })
        

    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()){
        TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            
            let user = User(dictionary: response as! NSDictionary)
            
            success(user)
            print("user: \(user.name)")

            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                
                failure(error)
                print("error getting current user")
              
        })

    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }

}
