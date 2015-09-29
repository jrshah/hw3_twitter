//
//  DetailsTweetViewController.swift
//  twitter
//
//  Created by Jay Shah on 9/28/15.
//  Copyright © 2015 Jay Shah. All rights reserved.
//

import UIKit

class DetailsTweetViewController: UIViewController {
    
    var currentTweet: Tweet?

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var handleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(currentTweet)

        // Do any additional setup after loading the view.
        self.nameLabel.text = currentTweet?.user?.name!
        self.handleLabel.text = "@\(currentTweet?.user?.screenname!)"
        self.tweetLabel.text = currentTweet?.text!
        
        self.profileImageView.setImageWithURL(NSURL(string: (currentTweet?.user?.profileImageURL!)!))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
