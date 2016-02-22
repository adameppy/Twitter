//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Adam Epstein on 2/21/16.
//  Copyright © 2016 Adam Epstein. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet]!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()


        }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
        
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        print("entered the function")
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.nameLabel.text = tweet.user?.name!
        cell.profileImage.setImageWithURL(((tweet.user?.profileURL))!)
        cell.screennameLabel.text = tweet.user?.screenname!
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        cell.timeLabel.text = formatter.stringFromDate(tweet.createdAt!)
        cell.tweetLabel.text = tweet.text!
        cell.retweetLabel.text = "\(tweet.retweetCount)"
        cell.favoriteLabel.text = "\(tweet.favoritesCount)"
            print(tweet.favoritesCount)
        return cell
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int{
            if(tweets != nil){
                return tweets.count
            }
            else{
                return 0
            }
        
    }


}
