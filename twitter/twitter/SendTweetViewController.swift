//
//  SendTweetViewController.swift
//  twitter
//
//  Created by Jay Shah on 9/28/15.
//  Copyright © 2015 Jay Shah. All rights reserved.
//

import UIKit

class SendTweetViewController: UIViewController {

    @IBOutlet weak var tweetTextField: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var thumbImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let user = User.currentUser
        
        self.userHandleLabel.text = "@\(user?.screenname!)"
        self.usernameLabel.text = user?.name
        self.thumbImage.setImageWithURL(NSURL(string: (user?.profileImageURL)!))
        
        self.tweetTextField.becomeFirstResponder()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendTweet(sender: AnyObject) {
        
        var parameters: [String : AnyObject] = ["status" : " "]
        
        parameters["status"] = self.tweetTextField.text as String
        
        TwitterClient.sharedInstance.statusUpdate(parameters) { (tweets, error) -> () in
            if error == nil {
                print(tweets)
                self.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                print("could not send tweet \(error)")
            }
        }
        
        

    }
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
