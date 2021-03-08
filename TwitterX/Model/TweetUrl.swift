//
//  TweetUrl.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import Foundation

struct TweetUrl: Decodable {
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "expanded_url"
    }
}
