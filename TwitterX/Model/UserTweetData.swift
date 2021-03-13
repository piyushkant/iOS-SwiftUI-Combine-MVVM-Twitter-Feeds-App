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
}

struct AttachedImage {
    let id: String
    let image: UIImage?
}
