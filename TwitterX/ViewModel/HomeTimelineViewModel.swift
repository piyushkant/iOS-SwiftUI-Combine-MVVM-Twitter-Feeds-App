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
    @Published var error: ApiError? = nil
    
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
                    if let tweetUrl = tweet.entities.urls.first?.url, let url = URL(string: tweetUrl) {
                        
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
    
    func fetchUserData(tweet: Tweet) -> UserData? {
        let userId = tweet.user.idStr
        
        for data in userData {
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
