//
//  VideoPlayerView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/20.
//

import SwiftUI
import AVKit
import VideoPlayer

struct VideoPlayerView: View {
    let url: URL
    let tweet: Tweet
    
    @State private var autoReplay: Bool = true
    @State private var mute: Bool = false
    @State private var play: Bool = true
    @State private var time: CMTime = .zero
    
    var body: some View {
        
        VideoPlayer(url: url, play: $play, time: $time)
            .autoReplay(autoReplay)
            .mute(mute)
            .aspectRatio(1.78, contentMode: .fit)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.7), radius: 6, x: 0, y: 2)
            .onAppear {
                try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
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
    
    @State private var autoReplay: Bool = true
    @State private var mute: Bool = false
    @State private var play: Bool = true
    @State private var time: CMTime = .zero
    
    var body: some View {
        
        VideoPlayer(url: url, play: $play, time: $time)
            .autoReplay(autoReplay)
            .mute(mute)
            .aspectRatio(1.78, contentMode: .fit)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.7), radius: 6, x: 0, y: 2)
            .onAppear {
            }
    }
}
