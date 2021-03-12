//
//  HomeView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/06.
//

import SwiftUI
import LinkPresentation

struct HomeTimelineConfig {
    static let TweetsLimit = 10
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
                    HomeTimelineCellView(tweet: tweets[i], isLast: true, homeTimelineViewModel: self.homeTimelineViewModel)
                } else {
                    HomeTimelineCellView(tweet: tweets[i], isLast: false, homeTimelineViewModel: self.homeTimelineViewModel)
                }
            }
            .onAppear {
                homeTimelineViewModel.fetchHomeTimeline(count: HomeTimelineConfig.TweetsLimit)
            }
            .navigationBarBackButtonHidden(true)
            .listStyle(PlainListStyle())
            .navigationBarTitle(Text(NSLocalizedString("homeTimeline", comment: "")))
            .navigationBarItems(trailing:
                                    Button("Settings") {}
            )
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
        //        Mark: Disabled for now due to api usage limit
        //        let tweets: [Tweet] = self.homeTimelineViewModel.tweets
        
        VStack(alignment: .leading, spacing: 10) {
            let headline = tweet.text
            
            if let userData = homeTimelineViewModel.fetchUserData(tweet: self.tweet), let data = userData.profileImageData {
                UserProfileImageView(data: data)
            }
            
            HyperlinkTextView(headline)
            
            if let link = homeTimelineViewModel.fetchLink(tweet: tweet) {
                LinkPreview(link: link)
                
            } else if let tweetUrl = tweet.entities.urls.first?.url, let url = URL(string: tweetUrl) {
                EmptyLinkPreview(url: url)
            }
            
            if self.isLast {
                Text("").onAppear {
                    
                    //                    Mark: Disabled for now due to api usage limit
                    //                    self.homeTimelineViewModel.fetchHomeTimeline(count: tweets.count + HomeTimelineConfig.TweetsLimit)
                }
            }
            
        }
    }
}

struct EmptyLinkPreview: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> LPLinkView {
        let linkView = LPLinkView(url: url)
        linkView.sizeToFit()
        
        return linkView
    }
    
    func updateUIView(_ uiView: LPLinkView, context: Context) {
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

struct UserProfileImageView: View {
    let data: Data
    
    var body: some View {
        Image(uiImage: UIImage(data: data) ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:50, height:50)
            .cornerRadius(50)
    }
}

