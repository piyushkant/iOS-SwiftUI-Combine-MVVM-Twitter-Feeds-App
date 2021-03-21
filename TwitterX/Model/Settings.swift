//
//  Settings.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/21.
//

import Foundation

struct Settings: Decodable {
    let screenName: String
    
    enum CodingKeys: String, CodingKey {
        case screenName = "screen_name"
    }
}
