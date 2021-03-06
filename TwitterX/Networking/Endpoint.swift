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
        
        case update(String)
        case destroy(Int)
        case homeTimeline
        
        var url: URL {
            switch self {
            case .update(let status):
                return EndPoint.baseURL.appendingPathComponent("statuses/update.json?status=\(status)")
            case .destroy(let id):
                return EndPoint.baseURL.appendingPathComponent("statuses/destroy/\(id).json")
            case .homeTimeline:
                return EndPoint.baseURL.appendingPathComponent("statuses/home_timeline.json")
            }
        }
    }
}
