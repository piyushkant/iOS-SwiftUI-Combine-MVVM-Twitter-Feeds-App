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
    static let sampleSingleImageTweetId = "1370325033663426560"
//    static let sampleSingleImageTweetId = "1370329824422551554"
//    static let sampleMultipleImageTweetId = "1370325033663426560"
//    static let sampleImageWithUrlId = "1370316972181848066"
//    static let sampleGifTweetId = "1366750878749761537"
//    static let sampleVideoTweetId = "1370320412177993739"
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
//                homeTimelineViewModel.fetchSingleTimeLine(id: HomeTimelineConfig.sampleSingleImageTweetId)
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
                UserView(tweet: self.tweet, data: data)
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

struct UserView: View {
    let tweet: Tweet
    let data: Data
    
    @State var currentDate = Date()
    private let timer = Timer.publish(every: 10, on: .main, in: .common)
      .autoconnect()
      .eraseToAnyPublisher()
    
    var body: some View {
        HStack(spacing: 10) {
            Image(uiImage: UIImage(data: data) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:50, height:50)
                .cornerRadius(50)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(tweet.user.name)
                    .bold()
                    .font(.system(size:18.0))
                PostTimeView(tweet: tweet, currentDate: currentDate)
            }
        }
        .onReceive(timer) {
          self.currentDate = $0
        }
    }
}

struct PostTimeView: View {
    let tweet: Tweet
    let currentDate: Date
    
    private static var relativeFormatter = RelativeDateTimeFormatter()
    
    private var relativeTimeString: String {
        if let dateCreated =  Utils.convertStringToDate(dateString: tweet.createdAt) {
            return PostTimeView.relativeFormatter.localizedString(fromTimeInterval: dateCreated.timeIntervalSince1970 - self.currentDate.timeIntervalSince1970)
        }
        return ""
    }
    
    var body: some View {
        Text("\(relativeTimeString) by @\(tweet.user.screenName)")
            .font(.system(size: 14))
            .foregroundColor(Color.gray)
    }
}


