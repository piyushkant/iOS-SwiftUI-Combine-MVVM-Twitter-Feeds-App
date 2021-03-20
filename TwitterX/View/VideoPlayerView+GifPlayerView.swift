//
//  VideoPlayerView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/20.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let url: URL
    let tweet: Tweet
    
    var body: some View {
        let player = AVPlayer(url: url)
        
        VideoPlayer(player: player)
            .frame(height: 197)
            .cornerRadius(10)
            .onAppear {
                try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                   
                player.play()
            }
            .onDisappear {
                player.pause()
            }
        
        if let extendedEntities = self.tweet.extendedEntities, let firstMedia = extendedEntities.media.first, let additionalMediaInfo = firstMedia.additionalMediaInfo {
            if let title = additionalMediaInfo.title, title != "" {
                Text(title)
                    .font(.system(size: 15))
                    .fontWeight(.bold)
            }

            if let description = additionalMediaInfo.description, description != "" {
                Text(description)
                    .font(.system(size: 15))
            }
        }
    }
}

struct GifPlayerView: View {
    let url: URL
    let tweet: Tweet
    
    init(url: URL, tweet: Tweet) {
        self.url = url
        self.tweet = tweet
        
        print("GifPlayerView", url)
    }
    
    var body: some View {
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
            .overlay(
                Text(NSLocalizedString("gif", comment: ""))
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity,  alignment: .topLeading)
                    .padding()
            )
            .cornerRadius(10)
    }
}
