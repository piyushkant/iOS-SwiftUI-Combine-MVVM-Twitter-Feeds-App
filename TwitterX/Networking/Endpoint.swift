//
//  Endpoint.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import Foundation

enum EndPoint {
    static let baseURL = URL(string: "https://api.twitter.com/1.1/")!
    
    enum Statuses {
        
        case show
        case homeTimeline
        case settings
        case destroy
        
        var url: URL {
            switch self {
            case .show:
                return EndPoint.baseURL.appendingPathComponent("statuses/show.json")
            case .settings:
                return EndPoint.baseURL.appendingPathComponent("account/settings.json")
            case .destroy:
                return EndPoint.baseURL.appendingPathComponent("statuses/destroy.json")
            case .homeTimeline:
                return EndPoint.baseURL.appendingPathComponent("statuses/home_timeline.json")
            }
        }
    }
}
