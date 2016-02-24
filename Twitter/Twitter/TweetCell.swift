//
//  TweetCell.swift
//  Twitter
//
//  Created by Adam Epstein on 2/21/16.
//  Copyright © 2016 Adam Epstein. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    var tweet: Tweet!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func retweet(sender: AnyObject) {
        
        var id = tweet.tweetid!
        
        TwitterClient.sharedInstance.POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("success retweeting")
            self.tweet.retweetCount++
            self.retweetLabel.text = "\(self.tweet.retweetCount)"

            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error retweeting")
                print(error)
        })

        
    }
    @IBAction func favorite(sender: AnyObject) {

        var id = tweet.tweetid!
        var params = ["id": id] as NSDictionary!
        TwitterClient.sharedInstance.POST("1.1/favorites/create.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("favorited \(self.tweet.text!)");
            self.tweet.favoritesCount++
            self.favoriteLabel.text = "\(self.tweet.favoritesCount)"
            print("success favoriting")
            //print("user: \(response)")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error favoriting")
                print(error)
        })
    }
}
