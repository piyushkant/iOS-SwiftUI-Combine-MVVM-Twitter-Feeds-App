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
                homeTimelineViewModel.fetchHomeTimeline(count: 1)
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
        //let tweets: [Tweet] = self.homeTimelineViewModel.tweets
        
        VStack(alignment: .leading, spacing: 10) {
            Text(tweet.text)
            
            if let tweetUrl = tweet.entities.urls.first?.url, let url = URL(string: tweetUrl) {
                //                URLPreview(previewURL: url, togglePreview: self.$togglePreview)
                
                let slp = SwiftLinkPreview(session: URLSession.shared,
                                           workQueue: SwiftLinkPreview.defaultWorkQueue,
                                           responseQueue: DispatchQueue.main,
                                           cache: DisabledCache.instance)
                
                let preview = slp.preview(tweetUrl,
                                          onSuccess: { result in print("\(result)") },
                                          onError: { error in print("\(error)")})
            }
            
            if (self.isLast) {
                Text("").onAppear {
                    //
                    //                    //Mark: Disabled for now due to api usage limit
                    //                    //self.homeTimelineViewModel.fetchHomeTimeline(count: tweets.count + 10)
                }
            }
            
        }.padding()
    }
}

struct URLPreview : UIViewRepresentable {
    var previewURL:URL
    
    @Binding var togglePreview: Bool
    
    func makeUIView(context: Context) -> LPLinkView {
        var linkView: LPLinkView
        
        if let existingMetadata = MetadataCache.retrieve(urlString: previewURL.absoluteString) {
            linkView = LPLinkView(metadata: existingMetadata)
        } else {
            linkView = LPLinkView(url: previewURL)
            let provider = LPMetadataProvider()
            
            provider.startFetchingMetadata(for: previewURL) { (metadata, error) in
                if let md = metadata {
                    DispatchQueue.main.async {
                        linkView.metadata = md
                        linkView.sizeToFit()
                        self.togglePreview.toggle()
                    }
                    
                    if let imageProvider = md.imageProvider {
                        md.iconProvider = imageProvider
                    }
                    MetadataCache.cache(metadata: md)
                }
            }
        }
        
        return linkView
    }
    
    func updateUIView(_ uiView: LPLinkView, context: UIViewRepresentableContext<URLPreview>) {
    }
}
