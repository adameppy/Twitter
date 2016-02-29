//
//  TweetViewController.swift
//  Twitter
//
//  Created by Adam Epstein on 2/25/16.
//  Copyright © 2016 Adam Epstein. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager


class TweetViewController: UIViewController {
    var tweet: Tweet!

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var retweetBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view currently loading")
        // Do any additional setup after loading the view, typically from a nib.
        nameLabel.text = tweet.user?.name!
        profileImage.setImageWithURL(((tweet.user?.profileURL))!)
        screennameLabel.text = tweet.user?.screenname!
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        dateLabel.text = formatter.stringFromDate(tweet.createdAt!)
        tweetLabel.text = tweet.text!
        retweetLabel.text = "\(tweet.retweetCount)"
        favoriteLabel.text = "\(tweet.favoritesCount)"
        //print(tweet.favoritesCount)
        if(tweet.favorited == true){
            let origImage = UIImage(named: "fav");
            let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            favoriteBtn.setImage(tintedImage, forState: .Normal)
            favoriteBtn.tintColor = UIColor.redColor()
        }
        if(tweet.retweeted == true){
            let origImage = UIImage(named: "retweet");
            let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            retweetBtn.setImage(tintedImage, forState: .Normal)
            retweetBtn.tintColor = UIColor.greenColor()
        }

    }
    
    @IBAction func retweet(sender: AnyObject) {
        var id = tweet.tweetid!
        
        if(tweet.retweeted == false){
            TwitterClient.sharedInstance.POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("success retweeting")
                self.tweet.retweeted = true
                self.tweet.retweetCount++
                self.retweetLabel.text = "\(self.tweet.retweetCount)"
                var res = response as! NSDictionary
                self.tweet.newtweetid = res["id_str"] as? String
                let origImage = UIImage(named: "retweet");
                let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                self.retweetBtn.setImage(tintedImage, forState: .Normal)
                self.retweetBtn.tintColor = UIColor.greenColor()
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error retweeting")
                    print(error)
            })
        }
        else{
            id = self.tweet.newtweetid!
            TwitterClient.sharedInstance.POST("1.1/statuses/destroy/\(id).json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("success deleting retweet")
                self.tweet.retweetCount--
                self.tweet.retweeted = false
                self.tweet.newtweetid = nil
                self.retweetLabel.text = "\(self.tweet.retweetCount)"
                self.tweet.favorited = false
                let origImage = UIImage(named: "retweet");
                let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                self.retweetBtn.setImage(tintedImage, forState: .Normal)
                self.retweetBtn.tintColor = UIColor.blackColor()
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error deleting retweet")
                    print(error)
            })
            
        }
    }
    
    @IBAction func favorite(sender: AnyObject) {
        var id = tweet.tweetid!
        var params = ["id": id] as NSDictionary!
        
        if(tweet.favorited == false){
            
            TwitterClient.sharedInstance.POST("1.1/favorites/create.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("favorited \(self.tweet.text!)");
                self.tweet.favoritesCount++
                self.favoriteLabel.text = "\(self.tweet.favoritesCount)"
                self.tweet.favorited = true
                let origImage = UIImage(named: "fav");
                let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                self.favoriteBtn.setImage(tintedImage, forState: .Normal)
                self.favoriteBtn.tintColor = UIColor.redColor()
                print("success favoriting")
                //print("user: \(response)")
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error favoriting")
                    print(error)
            })
            
        }
        else{
            
            TwitterClient.sharedInstance.POST("1.1/favorites/destroy.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("favorited \(self.tweet.text!)");
                self.tweet.favoritesCount--
                self.favoriteLabel.text = "\(self.tweet.favoritesCount)"
                self.tweet.favorited = false
                let origImage = UIImage(named: "fav");
                let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                self.favoriteBtn.setImage(tintedImage, forState: .Normal)
                self.favoriteBtn.tintColor = UIColor.blackColor()
                print("success deleting favorite")
                //print("user: \(response)")
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error deleting favorite")
                    print(error)
            })
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "composeSegue"){
            print("segueing to compose")
            let controller = segue.destinationViewController as! ComposeViewController
            controller.reply_id = tweet.tweetid!
            controller.reply_screenname = tweet.user?.screenname!
        }
    }
}
