//
//  HomeCellView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/17.
//

import SwiftUI
import AVKit
import SDWebImageSwiftUI

struct HomeCellView: View {
    let tweet: Tweet
    var isLast: Bool
    @ObservedObject var homeViewModel: HomeViewModel
    @State var togglePreview = false
    
    var body: some View {
        //        Mark: Disabled for now due to api usage limit
        //        let tweets: [Tweet] = self.homeViewModel.tweets
        
        VStack(alignment: .leading, spacing: 10) {
            let headline = tweet.text
            
            if let userInfoData = homeViewModel.fetchUserData(tweet: self.tweet), let data = userInfoData.profileImageData {
                UserInfoView(tweet: self.tweet, data: data)
            }
            
            HyperlinkTextView(headline)
                .fixedSize(horizontal: false, vertical: true)
            

            if let userTweetData = homeViewModel.fetchUserTweetData(tweet: self.tweet) {
                let mediaType = homeViewModel.mediaType
                
                if (mediaType == .Gif) {
                    if let firstData = homeViewModel.userTweetData.first, let videoUrl = firstData.attachedVideoUrl, let url = URL(string: videoUrl) {
                        GifPlayerView(url: url, tweet: self.tweet)
                    }
                } else if (mediaType == .Video) {
                    if let firstData = homeViewModel.userTweetData.first, let videoUrl = firstData.attachedVideoUrl, let url = URL(string: videoUrl) {
                        VideoPlayerView(url: url, tweet: self.tweet)
                    }
                } else if (mediaType == .Images) {
                    if let attachedImages = userTweetData.attachedImages {
                        let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
                        
                        LazyVGrid(columns: columns, alignment: .center, spacing: 10, content: {
                            ForEach(attachedImages, id:\.self) { image in
                                ImageGridView(homeViewModel: homeViewModel, image: image)
                            }
                        })
                        .padding(.top)
                        .overlay(
                            ImageTabView(homeViewModel: homeViewModel, images: attachedImages)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.4, alignment: .leading)
                        )
                    }
                } else {
                    if let link = homeViewModel.fetchLink(tweet: tweet) {
                        LinkPreview(link: link)
                    } else if let tweetUrl = tweet.entities.urls.first?.url, let url = URL(string: tweetUrl) {
                        EmptyLinkPreview(url: url)
                    }
                }
            }
            
            if self.isLast {
                Text("").onAppear {
                    
                    //                    Mark: Disabled for now due to api usage limit
                    //                    self.homeViewModel.fetchHomeTimeline(count: tweets.count + HomeTimelineConfig.TweetsLimit)
                }
            }
            
        }
    }
}
