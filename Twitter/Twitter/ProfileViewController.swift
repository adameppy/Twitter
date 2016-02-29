//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Adam Epstein on 2/28/16.
//  Copyright © 2016 Adam Epstein. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

class ProfileViewController: UIViewController {
    var user: User!
    var user_info: NSDictionary?
    
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        var params = ["screen_name": user.screenname!]
        TwitterClient.sharedInstance.GET("1.1/users/show.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            self.user_info = response as! NSDictionary!

            print("user: \(response)")
            if let bannerImageURL = self.user_info!["profile_banner_url"]{
                self.bannerImage.setImageWithURL(NSURL(string: bannerImageURL as! String)!)

            }
            self.profileImage.setImageWithURL(self.user.profileURL!)
            self.nameLabel.text = self.user.name!
            self.screennameLabel.text = self.user.screenname!
            var description = self.user_info!["description"] as! String
            self.descriptionLabel.text = description
            var numtweets = self.user_info!["statuses_count"] as! Int
            self.tweetsLabel.text = "\(numtweets)"
            var numfollowing = self.user_info!["friends_count"] as! Int
            self.followingLabel.text = "\(numfollowing)"
            var numfollowers = self.user_info!["followers_count"] as! Int
            self.followersLabel.text = "\(numfollowers)"
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting user info")
                print(error)
        })
        print("passed the get")

        
        
    }
    

}
