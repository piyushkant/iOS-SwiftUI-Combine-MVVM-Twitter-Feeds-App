//
//  TweetExtendedEntities.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/13.
//

import Foundation

struct TweetExtendedEntities: Decodable {
    let media: [TweetMedia]
    
    enum CodingKeys: String, CodingKey {
        case media = "media"
    }
}

struct TweetMedia: Decodable {
    let mediaUrl: String
    let videoInfo: TweetVideoInfo?
    let additionalMediaInfo: AdditionalMediaInfo?
    
    enum CodingKeys: String, CodingKey {
        case mediaUrl = "media_url_https"
        case videoInfo = "video_info"
        case additionalMediaInfo = "additional_media_info"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.mediaUrl = try values.decode(String.self, forKey: .mediaUrl)
        
        if values.contains(.videoInfo) {
            self.videoInfo = try values.decode(TweetVideoInfo.self, forKey: .videoInfo)
        } else {
            self.videoInfo = nil
        }
        
        if values.contains(.additionalMediaInfo) {
            self.additionalMediaInfo = try values.decode(AdditionalMediaInfo.self, forKey: .additionalMediaInfo)
        } else {
            self.additionalMediaInfo = nil
        }
    }
}

struct TweetVideoInfo: Decodable {
    let variants: [VideoVariants]
    
    enum CodingKeys: String, CodingKey {
        case variants = "variants"
    }
}

struct VideoVariants: Decodable {
    let bitrate: Int?
    let contentType: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case bitrate = "bitrate"
        case contentType = "content_type"
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.contentType = try values.decode(String.self, forKey: .contentType)
        self.url = try values.decode(String.self, forKey: .url)
        
        if values.contains(.bitrate) {
            self.bitrate = try values.decode(Int.self, forKey: .bitrate)
        } else {
            self.bitrate = nil
        }
    }
}

struct AdditionalMediaInfo: Decodable {
    let title: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if values.contains(.title) {
            self.title = try values.decode(String.self, forKey: .title)
        } else {
            self.title = nil
        }
        
        if values.contains(.description) {
            self.description = try values.decode(String.self, forKey: .description)
        } else {
            self.description = nil
        }
    }
}

public enum MediaType {
    case Links
    case Images
    case Video
    case Gif
}


enum VideoBitrate {
    case Zero
    case Low
    case Medium
    case High
    
    var value: Int {
        switch self {
        case .Zero:
            return 0
        case .Low:
            return 288000
        case .Medium:
            return 832000
        case .High:
            return 2176000
        }
    }
}
