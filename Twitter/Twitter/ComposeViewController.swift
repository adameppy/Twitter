//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Adam Epstein on 2/28/16.
//  Copyright © 2016 Adam Epstein. All rights reserved.
//


import UIKit
import AFNetworking
import BDBOAuth1Manager

class ComposeViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var reply_id: String?
    var reply_screenname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(reply_screenname != nil){
            textView.text = "\(reply_screenname!) "
        }
    }
    
    
    @IBAction func done(sender: AnyObject) {
        var status = textView.text as String
        var params = ["status": status] as NSDictionary!
        if reply_id != nil{
            params = ["status": status, "in_reply_to_status_id": reply_id!] as NSDictionary!
        }
        TwitterClient.sharedInstance.POST("1.1/statuses/update.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("success posting")
            
            var res = response as! NSDictionary
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error posting")
                print(error)
        })
        
        self.dismissViewControllerAnimated(false, completion: nil)
        print("done")
        
        
        
    }
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
        print("cancel")
    }
}
