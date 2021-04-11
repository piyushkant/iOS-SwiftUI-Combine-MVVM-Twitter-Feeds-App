//
//  Endpoint.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import Foundation

enum EndPoint {
    static let baseURL = URL(string: "https://api.twitter.com/1.1/")!
    
    case showTweet
    case homeTimeline
    case accountSettings
    case deleteTweet
    case unfollowUser
    
    var url: URL {
        switch self {
        case .showTweet:
            return EndPoint.baseURL.appendingPathComponent("statuses/show.json")
        case .accountSettings:
            return EndPoint.baseURL.appendingPathComponent("account/settings.json")
        case .deleteTweet:
            return EndPoint.baseURL.appendingPathComponent("statuses/destroy.json")
        case .homeTimeline:
            return EndPoint.baseURL.appendingPathComponent("statuses/home_timeline.json")
        case .unfollowUser:
            return EndPoint.baseURL.appendingPathComponent("friendships/destroy.json")
        }
    }
}
