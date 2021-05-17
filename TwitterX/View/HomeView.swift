//
//  HomeView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/06.
//

import SwiftUI

struct HomeConfig {
    static let TweetsLimit = 10
    static let sampleTexttweet = "1373575870506364928"
    static let sampleLinkTweetId = "1373060163687567366"
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
        NavigationView {
            List {
                ForEach(self.homeViewModel.tweets.indices, id: \.self) { index in
                    HomeCellView(tweet: self.homeViewModel.tweets[index], isLast: self.homeViewModel.tweets.count - 1 == index, homeViewModel: self.homeViewModel)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .onAppear {
                homeViewModel.fetchHomeTimeline(count: HomeConfig.TweetsLimit)
            }
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .listStyle(PlainListStyle())
            .navigationBarTitle(Text("TwitterX"), displayMode: .inline)
            .navigationBarItems(trailing: FetchView(homeViewModel: homeViewModel))
        }
    }
}

struct FetchView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        EmptyView().onAppear {
            homeViewModel.fetchHomeTimeline(count: HomeConfig.TweetsLimit)
        }
    }
}






