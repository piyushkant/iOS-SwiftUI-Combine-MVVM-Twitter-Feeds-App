//
//  HomeView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/06.
//

import SwiftUI
import LinkPresentation
import SwiftLinkPreview

struct HomeTimelineView: View {
    let showTweets = 10
    
    @ObservedObject var homeTimelineViewModel: HomeTimelineViewModel
    
    init() {
        homeTimelineViewModel = HomeTimelineViewModel()
    }
    
    var body: some View {
        let tweets: [Tweet] = self.homeTimelineViewModel.tweets
        
        NavigationView {
            List(0..<tweets.count, id: \.self) { i in
                if i == tweets.count - 1 {
                    HomeTimelineCellView(tweet: tweets[i], isLast: true, homeTimelineViewModel: self.homeTimelineViewModel)
                } else {
                    HomeTimelineCellView(tweet: tweets[i], isLast: false, homeTimelineViewModel: self.homeTimelineViewModel)
                }
            }.onAppear {
                homeTimelineViewModel.fetchHomeTimeline(count: self.showTweets)
            }
            .navigationBarTitle(Text(NSLocalizedString("homeTimeline", comment: "")))
            .navigationBarItems(trailing:
                                    Button("Settings") {}
            )
            .navigationBarBackButtonHidden(true)
            .listStyle(PlainListStyle())
        }
    }
}

struct HomeTimelineCellView: View {
    let tweet: Tweet
    var isLast: Bool
    @ObservedObject var homeTimelineViewModel: HomeTimelineViewModel
    @State var togglePreview = false
    
    init(tweet: Tweet, isLast: Bool, homeTimelineViewModel: HomeTimelineViewModel) {
        self.tweet = tweet
        self.isLast = isLast
        self.homeTimelineViewModel = homeTimelineViewModel
    }
    
    var body: some View {
        //Mark: Disabled for now due to api usage limit
        //let tweets: [Tweet] = self.homeTimelineViewModel.tweets
        
        VStack(alignment: .leading, spacing: 10) {
            Text(tweet.text)
            
            if let link = homeTimelineViewModel.fetchLink(tweet: tweet) {
                LinkPreview(link: link)
            } else {
                if let tweetUrl = tweet.entities.urls.first?.url {
                    Text(tweetUrl)
                }
            }
            
            if (self.isLast) {
                Text("").onAppear {
                    
                    //Mark: Disabled for now due to api usage limit
                    //self.homeTimelineViewModel.fetchHomeTimeline(count: tweets.count + 10)
                }
            }
            
        }.padding()
    }
}

struct LinkPreview: UIViewRepresentable {
    var link: Link
    
    func makeUIView(context: Context) -> LPLinkView {        
        let linkView = LPLinkView(url: link.url)
        
        linkView.metadata = link.data
        linkView.sizeToFit()
        
        return linkView
    }
    
    func updateUIView(_ uiView: LPLinkView, context: Context) {
    }
}
