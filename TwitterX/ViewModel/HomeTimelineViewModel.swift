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

class HomeTimelineViewModel: ObservableObject {
    private let api: Api
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var tweets = [Tweet]()
    @Published var links = [Link]()
    @Published var userData = [UserData]()
    @Published var userTweetData = [UserTweetData]()
    @Published var error: ApiError? = nil
    @Published var showImageViewer = false
    @Published var selectedImageID = ""
    @Published var imageViewerOffset: CGSize = .zero
    @Published var bgOpacity: Double = 1
    @Published var imageScale: CGFloat = 1
    @Published var mediaType = MediaType.LINKS
    
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
                    let user = tweet.user
                    let profileImageUrl = user.profileImageUrl
                    
                    if let imageUrl = URL(string: profileImageUrl) {
                        let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                            guard let data = data else { return }
                            DispatchQueue.main.async {
                                self.userData.append(UserData(id: tweet.user.idStr, profileImageData: data))
                            }
                        }
                        task.resume()
                    }
                    
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
                
                self.error = nil
            })
            .store(in: &subscriptions)
    }
    
    //Mark: Remove me, only for testing purpose
    func fetchSingleTimeLine(id: String) {
        api
            .show(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
            }, receiveValue: { tweet in
                self.tweets.append(tweet)
                
                //Mark: user info data
                let user = tweet.user
                let profileImageUrl = user.profileImageUrl
                
                if let imageUrl = URL(string: profileImageUrl) {
                    let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                        guard let data = data else { return }
                        DispatchQueue.main.async {
                            self.userData.append(UserData(id: tweet.user.idStr, profileImageData: data))
                        }
                    }
                    task.resume()
                }
                
                //Mark: user tweet data
                self.mediaType = .LINKS
                let media = tweet.extendedEntities.media
                
                if let videoInfo = media.first?.videoInfo {
                    let videoVariants = videoInfo.variants
                    
                    for variant in videoVariants {
                        if let bitrate = variant.bitrate, bitrate == VideoBitrate.zero.value  {
                            self.mediaType = .GIF
                            self.userTweetData.append(UserTweetData(id: tweet.user.idStr, attachedImages: nil, attachedVideoUrl: variant.url))
                            break
                        }
                    }
                    
                    if (self.mediaType != .GIF) {
                        for variant in videoVariants {
                            if let bitrate = variant.bitrate, bitrate == VideoBitrate.high.value { //Mark: Using high bitrate video
                                self.mediaType = .VIDEO
                                self.userTweetData.append(UserTweetData(id: tweet.user.idStr, attachedImages: nil, attachedVideoUrl: variant.url))
                                break
                            }
                        }
                    }
                } else {
                    self.mediaType = .IMAGES
                    var attachedImages = [AttachedImage]()
                    var count = 0
                    for m in media {
                        if let imageUrl = URL(string: m.mediaUrl) {
                            let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                                guard let data = data else { return }
                                
                                attachedImages.append(AttachedImage(id: String(describing: count), image: UIImage(data: data) ?? UIImage()))
                                
                                count += 1
                                
                                if media.count >= count {
                                    DispatchQueue.main.async {
                                        self.userTweetData.append(UserTweetData(id: tweet.user.idStr, attachedImages: attachedImages, attachedVideoUrl: nil))
                                    }
                                }
                            }
                            task.resume()
                        }
                    }
                }
                
                //                //Mark: user tweet links
                //                if let tweetUrl = tweet.entities.urls.first?.url, let url = URL(string: tweetUrl) {
                //                    let provider = LPMetadataProvider()
                //
                //                    provider.startFetchingMetadata(for: url) { metaData, error in
                //                        guard let data = metaData, error == nil else {
                //                            return
                //                        }
                //                        DispatchQueue.main.async {
                //                            self.links.append(Link(id: tweet.idStr, url: url, data: data))
                //                        }
                //                    }
                //                }
                //
                self.error = nil
            })
            .store(in: &subscriptions)
    }
    
    func fetchUserData(tweet: Tweet) -> UserData? {
        let userId = tweet.user.idStr
        
        for data in userData {
            if data.id == userId {
                return data
            }
        }
        return nil
    }
    
    func fetchUserTweetData(tweet: Tweet) -> UserTweetData? {
        let userId = tweet.user.idStr
        
        for data in userTweetData {
            if data.id == userId {
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
