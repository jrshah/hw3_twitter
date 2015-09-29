//
//  TwiterClient.swift
//  twitter
//
//  Created by Jay Shah on 9/26/15.
//  Copyright © 2015 Jay Shah. All rights reserved.
//

import UIKit

let twitterConsumerKey = "qLXaekuLoR5K1GvWIdkVUCI9M"
let twitterConsumerSecret = "5iXbqrel7IaH4d0tZ1ePUYJ4uiBOtXdgHTZIRC0l6bzeylPiDx"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?

    class var sharedInstance: TwitterClient {

        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
        func statusUpdate (params: NSDictionary?, completion: (tweets : Tweet?, error: NSError?) -> () )  {
        
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            //send the tweet
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweets: tweet, error: nil)
            print("tweet sent")
            
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            
            print("error sending tweet")
            completion(tweets: nil, error: error)
            
        }
    }
    
    func homeTimeLineWithParam(params: NSDictionary?, completion: (tweets : [Tweet]?, error: NSError?) -> () ) {
        
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            
            completion(tweets: tweets, error: nil)
            
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completion(tweets: nil, error: error )
        })

    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        
        self.loginCompletion = completion
        
        // Fetch my request token and redirect to authorization page
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            print("Got the request token \(requestToken.token)")
            
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (error: NSError!) -> Void in
                
                print("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url : NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: {( accessToken: BDBOAuth1Credential!)  -> Void in
            
            print("Got the access token \(accessToken)")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                print("Got the user")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                
                self.loginCompletion?(user: user, error: nil)
                
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                
                print ("error getting current user")
                self.loginCompletion?(user: nil, error: error)
            })
            
        }) { (error: NSError!) -> Void in
            
            print("did not get access token")
            self.loginCompletion?(user: nil, error: error)
        
        }

        
    }
}
