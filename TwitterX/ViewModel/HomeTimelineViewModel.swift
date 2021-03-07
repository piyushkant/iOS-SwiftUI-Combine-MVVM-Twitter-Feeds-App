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
                    print(tweet.text)
                }
                
                self.error = nil
            })
            .store(in: &subscriptions)
    }
    
    func fetchLinkPreview(url: String, completionHandler: @escaping (LinkPreviewResult) -> ())  {
        guard let url = URL(string: url) else {
            completionHandler(.failure(["message" : "Error: url is not corect"]))
            return
        }
        
        let linkPreview = LPLinkView()
        let provider = LPMetadataProvider()
        
        provider.startFetchingMetadata(for: url) { metaData, error in
            guard let data = metaData, error == nil else {
                completionHandler(.failure(["message" : "Error: \(String(describing: error))"]))
                return
            }
            
            linkPreview.metadata = data
            completionHandler(.success(linkPreview))
        }
    }
}
