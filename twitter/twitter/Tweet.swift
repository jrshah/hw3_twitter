//
//  Tweet.swift
//  twitter
//
//  Created by Jay Shah on 9/26/15.
//  Copyright © 2015 Jay Shah. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var time: String?
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
        createdAt = formatter.dateFromString(createdAtString!)
        
        let now = NSDate()
        
        let interval = Int(now.timeIntervalSinceDate(createdAt!))
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        
        if (hours > 23){
            time = String(format: "%01dh %01dm", hours, minutes)
        } else if (hours > 0) {
            time = String(format: "%01dh %01dm", hours, minutes)
        } else {
            time = String(format: "%01dm", minutes)
        }
        
    }
    
    
    class func tweetsWithArray (array: [NSDictionary]) -> [Tweet] {
        
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }

}


