//
//  TimelineViewModel.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import SwiftUI
import Combine
import Firebase

class HomeTimelineViewModel: ObservableObject {
    private let api: Api
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var homeTimelineTweets = [Tweet]()
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
            }, receiveValue: { homeTimelineTweets in
                self.homeTimelineTweets = homeTimelineTweets
                
                for tweet in homeTimelineTweets {
                    print(tweet.text)
                }
                
                self.error = nil
            })
            .store(in: &subscriptions)
    }
}
