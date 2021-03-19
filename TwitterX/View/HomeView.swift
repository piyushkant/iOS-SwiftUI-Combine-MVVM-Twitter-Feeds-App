//
//  HomeView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/06.
//

import SwiftUI

struct HomeConfig {
    static let TweetsLimit = 10
    static let sampleSingleImageTweetId = "1370325033663426560" //1370325033663426560 //1370329824422551554
    static let sampleMultipleImageTweetId = "1370337291214888962"
    static let sampleImageWithUrlId = "1370316972181848066"
    static let sampleGifTweetId = "1372212724554473472" //1370922422233358336 //1372212724554473472 //1372214089389252611
    static let sampleVideoTweetId = "1373024204816314368"  //"1370320412177993739"
}

struct HomeView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    init() {
        homeViewModel = HomeViewModel()
    }
    
    var body: some View {
        let tweets: [Tweet] = self.homeViewModel.tweets
        
        NavigationView {
            List(0..<tweets.count, id: \.self) { i in
                HomeCellView(tweet: tweets[i], isLast: tweets.count - 1 == i, homeViewModel: self.homeViewModel)
            }
            .buttonStyle(PlainButtonStyle())
            .onAppear {
                //                homeTimelineViewModel.fetchHomeTimeline(count: HomeTimelineConfig.TweetsLimit)
                homeViewModel.fetchSingleTimeLine(id: HomeConfig.sampleVideoTweetId)
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






