//
//  TimelineViewModel.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import SwiftUI
import Combine
import Firebase
import LinkPresentation

enum LinkPreviewResult {
    case success (LPLinkView)
    case failure ([String: String])
}

class HomeViewModel: ObservableObject {
    private let api: Api
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var tweets = [Tweet]()
    @Published var links = [Link]()
    @Published var userInfoData = [UserData]()
    @Published var userTweetData = [UserTweetData]()
    @Published var error: ApiError? = nil
    @Published var showImageViewer = false
    @Published var imageViewerOffset: CGSize = .zero
    @Published var bgOpacity: Double = 1
    @Published var imageScale: CGFloat = 1
    
    init() {
        self.api = Api(oauth: OAuth())
    }
    
    func fetchHomeTimeline(count: Int) {
        api
            .homeTimeline(count: count)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
            }, receiveValue: { tweets in
                self.tweets = tweets
                
                for tweet in tweets {
                    
                    //Mark: user info data
                    let user = tweet.user
                    let profileImageUrl = user.profileImageUrl
                    
                    if let imageUrl = URL(string: profileImageUrl) {
                        let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                            guard let data = data else { return }
                            DispatchQueue.main.async {
                                self.userInfoData.append(UserData(id: tweet.idStr, profileImageData: data))
                            }
                        }
                        task.resume()
                    }
                    
                    //Mark: user tweet data                    
                    if let extendedEntities = tweet.extendedEntities {
                        let media = extendedEntities.media
                       
                        if let videoInfo = media.first?.videoInfo {
                            let videoVariants = videoInfo.variants
                            var isGif = false
                            
                            for variant in videoVariants {
                                if let bitrate = variant.bitrate, bitrate == VideoBitrate.Zero.value  {
                                    isGif = true
                                    let gifData = UserTweetData(id: tweet.idStr, attachedImages: nil, attachedVideoUrl: variant.url, mediaType: .Gif)
                                    self.userTweetData.append(gifData)
                                    
                                    break
                                }
                            }
                            
                            if !isGif {
                                for variant in videoVariants {
                                    if let bitrate = variant.bitrate, bitrate == VideoBitrate.High.value { //Mark: Using high bitrate video
                                        
                                        let videoData = UserTweetData(id: tweet.idStr, attachedImages: nil, attachedVideoUrl: variant.url, mediaType: .Video)
                                        self.userTweetData.append(videoData)
                                       
                                        break
                                    }
                                }
                            }
                        } else {
                            var attachedImages = [AttachedImage]()
                            var count = 0
                            for m in media {
                                if let imageUrl = URL(string: m.mediaUrl) {
                                    let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                                        guard let data = data else { return }
                                        
                                        attachedImages.append(AttachedImage(id: String(describing: count), image: UIImage(data: data) ?? UIImage()))
                                        
                                        count += 1
                                        
                                        if count >= media.count {
                                            DispatchQueue.main.async {
                                                
                                                let imagesData = UserTweetData(id: tweet.idStr, attachedImages: attachedImages, attachedVideoUrl: nil, mediaType: .Images)
                                                self.userTweetData.append(imagesData)
                                            }
                                        }
                                    }
                                    task.resume()
                                }
                            }
                        }
                    } else {
                        //Mark: user tweet links
                        if let tweetUrl = tweet.entities.urls.first?.url, let url = URL(string: tweetUrl) {
                            
                            let provider = LPMetadataProvider()
                            
                            provider.startFetchingMetadata(for: url) { metaData, error in
                                guard let data = metaData, error == nil else {
                                    return
                                }
                                DispatchQueue.main.async {
                                    self.links.append(Link(id: tweet.idStr, url: url, data: data))
                                }
                            }
                        }
                    }
                } 
                
                self.error = nil
            })
            .store(in: &subscriptions)
    }
    
    func destroy(id: String) {
        print("destroy", id)
        
        api
            .destroy(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
            }, receiveValue: { tweet in
                DispatchQueue.main.async {
                    let index = self.findTweetIndexById(id: id)
                    print("destroy", index, tweet)
                   
                    if index >= 0 {
                        self.tweets.remove(at: index)
                    }
                }
                
                self.error = nil
            })
            .store(in: &subscriptions)
    }
    
    func findTweetIndexById(id: String) -> Int {
        var index = 0
        for tweet in self.tweets {
            if tweet.idStr == id {
                return index
            }
            
            index += 1
        }
        
        return -1
    }
    
    func fetchUserData(tweet: Tweet) -> UserData? {
        let userId = tweet.idStr
        
        for data in userInfoData {
            if data.id == userId {
                return data
            }
        }
        return nil
    }
    
    func fetchUserTweetData(tweet: Tweet) -> UserTweetData? {
        let tweetId = tweet.idStr
        
        for data in userTweetData {
            if data.id == tweetId {
                return data
            }
        }
        return nil
    }
    
    func fetchLink(tweet: Tweet) -> Link? {
        let id = tweet.idStr
        
        for link in links {
            if link.id == id {
                return link
            }
        }
        return nil
    }
}
