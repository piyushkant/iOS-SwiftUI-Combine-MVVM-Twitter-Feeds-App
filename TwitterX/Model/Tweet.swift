//
//  HomeTimeline.swift
//  TwitterClient (iOS)
//
//  Created by Piyush Kant on 2021/03/05.
//

import SwiftUI

struct Tweet: Codable, Identifiable {
    let id: Int
    //    let createdAt: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        //        case createdAt = "created_at"
        case text = "text"
        
    }
}

