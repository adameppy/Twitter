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
        //self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0, green: 132.0/255.0, blue: 180.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
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
        //print("entered the function")
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
            //print(tweet.favoritesCount)
        if(tweet.favorited == true){
            let origImage = UIImage(named: "fav");
            let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.favoriteBtn.setImage(tintedImage, forState: .Normal)
            cell.favoriteBtn.tintColor = UIColor.redColor()
        }
        if(tweet.retweeted == true){
            let origImage = UIImage(named: "retweet");
            let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.retweetBtn.setImage(tintedImage, forState: .Normal)
            cell.retweetBtn.tintColor = UIColor.greenColor()
        }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "tweetSegue"){
            print("segueing to tweet")
            let controller = segue.destinationViewController as! TweetViewController
            controller.tweet = tweets[tableView.indexPathForSelectedRow!.row]
        }
        else if(segue.identifier == "profileSegue"){
            let controller = segue.destinationViewController as! ProfileViewController
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! TweetCell
            let indexPath = tableView.indexPathForCell(cell)
            controller.user = tweets[indexPath!.row].user
            
        }
            
    }


}
