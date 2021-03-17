//
//  HomeView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/06.
//

import SwiftUI

struct HomeTimelineConfig {
    static let TweetsLimit = 10
    static let sampleSingleImageTweetId = "1370325033663426560" //1370325033663426560 //1370329824422551554
    static let sampleMultipleImageTweetId = "1370337291214888962"
    static let sampleImageWithUrlId = "1370316972181848066"
    static let sampleGifTweetId = "1370922422233358336"
    static let sampleVideoTweetId = "1370320412177993739"
}

struct HomeTimelineView: View {
    @ObservedObject var homeTimelineViewModel: HomeTimelineViewModel
    
    init() {
        homeTimelineViewModel = HomeTimelineViewModel()
    }
    
    var body: some View {
        let tweets: [Tweet] = self.homeTimelineViewModel.tweets
        
        NavigationView {
            List(0..<tweets.count, id: \.self) { i in
                if i == tweets.count - 1 {
                    HomeCellView(tweet: tweets[i], isLast: true, homeTimelineViewModel: self.homeTimelineViewModel)
                } else {
                    HomeCellView(tweet: tweets[i], isLast: false, homeTimelineViewModel: self.homeTimelineViewModel)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .onAppear {
                //                homeTimelineViewModel.fetchHomeTimeline(count: HomeTimelineConfig.TweetsLimit)
                homeTimelineViewModel.fetchSingleTimeLine(id: HomeTimelineConfig.sampleMultipleImageTweetId)
            }
            .navigationBarBackButtonHidden(true)
            .listStyle(PlainListStyle())
            //            .navigationBarTitle(Text(NSLocalizedString("homeTimeline", comment: "")))
            .navigationBarItems(trailing:
                                    Button("Settings") {}
            )
        }
    }
}






