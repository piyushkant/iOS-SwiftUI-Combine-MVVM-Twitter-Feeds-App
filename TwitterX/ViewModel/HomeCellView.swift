//
//  HomeCellView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/17.
//

import SwiftUI
import AVKit

struct HomeCellView: View {
    let tweet: Tweet
    var isLast: Bool
    @ObservedObject var homeTimelineViewModel: HomeTimelineViewModel
    @State var togglePreview = false
    
    var body: some View {
        //        Mark: Disabled for now due to api usage limit
        //        let tweets: [Tweet] = self.homeTimelineViewModel.tweets
        
        VStack(alignment: .leading, spacing: 10) {
            let headline = tweet.text
            
            if let userData = homeTimelineViewModel.fetchUserData(tweet: self.tweet), let data = userData.profileImageData {
                UserInfoView(tweet: self.tweet, data: data)
            }
            
            HyperlinkTextView(headline)
                .fixedSize(horizontal: false, vertical: true)
            

            if let userTweetData = homeTimelineViewModel.fetchUserTweetData(tweet: self.tweet) {
                let mediaType = homeTimelineViewModel.mediaType
                
                //Mark: for now gif will act as video. Fix this if found some good solution
                if (mediaType == .GIF) {
                    /*let gifUrl = homeTimelineViewModel.userTweetData.first?.attachedVideoUrl
                     
                     if let gifUrl = gifUrl, let url = URL(string: gifUrl) {
                     GifView(url: url)
                     .frame(height: 197)
                     .cornerRadius(10)

                     }*/
                    
                    let videoUrl = homeTimelineViewModel.userTweetData.first?.attachedVideoUrl

                    if let videoUrl = videoUrl, let url = URL(string: videoUrl) {
                        let player = AVPlayer(url: url)

                        VideoPlayer(player: player)
                            .frame(height: 197)
                            .cornerRadius(10)
                            .onAppear {
                                player.play()
                            }
                            .onDisappear {
                                player.pause()
                            }
                    }
                } else if (mediaType == .VIDEO) {
                    let videoUrl = homeTimelineViewModel.userTweetData.first?.attachedVideoUrl

                    if let videoUrl = videoUrl, let url = URL(string: videoUrl) {
                        let player = AVPlayer(url: url)
                        
                        VideoPlayer(player: player)
                            .frame(height: 197)
                            .cornerRadius(10)
                            .onAppear {
                                player.play()
                            }
                            .onDisappear {
                                player.pause()
                            }
                    }
                } else if (mediaType == .IMAGES) {
                    if let attachedImages = userTweetData.attachedImages {
                        let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
                        
                        LazyVGrid(columns: columns, alignment: .center, spacing: 10, content: {
                            ForEach(attachedImages, id:\.self) { image in
                                ImageGridView(homeTimelineViewModel: homeTimelineViewModel, image: image)
                            }
                        })
                        .padding(.top)
                        .overlay(
                            ImageTabView(homeTimelineViewModel: homeTimelineViewModel, images: attachedImages)
                        )
                    }
                } else {
                    if let link = homeTimelineViewModel.fetchLink(tweet: tweet) {
                        LinkPreview(link: link)
                    } else if let tweetUrl = tweet.entities.urls.first?.url, let url = URL(string: tweetUrl) {
                        EmptyLinkPreview(url: url)
                    }
                }
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
