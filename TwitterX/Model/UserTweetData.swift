//
//  TweetData.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/13.
//

import SwiftUI

struct UserTweetData {
    let id: String
    let attachedImages: [AttachedImage]?
    let attachedVideoUrl: String?
    let mediaType: MediaType
}

struct AttachedImage: Hashable {
    let id: String
    let image: UIImage?
}
