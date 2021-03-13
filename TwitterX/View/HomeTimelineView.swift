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
    static let sampleMultipleImageTweetId = "1370337291214888962"
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
                    HomeTimelineCellView(index: i, tweet: tweets[i], isLast: true, homeTimelineViewModel: self.homeTimelineViewModel)
                } else {
                    HomeTimelineCellView(index: i, tweet: tweets[i], isLast: false, homeTimelineViewModel: self.homeTimelineViewModel)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .onAppear {
                //                homeTimelineViewModel.fetchHomeTimeline(count: HomeTimelineConfig.TweetsLimit)
                homeTimelineViewModel.fetchSingleTimeLine(id: HomeTimelineConfig.sampleMultipleImageTweetId)
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
    let index: Int
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
                UserView(tweet: self.tweet, data: data)
            }
            
            HyperlinkTextView(headline)
            
            if let _ = homeTimelineViewModel.fetchUserTweetData(tweet: self.tweet) {
                let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
                
                LazyVGrid(columns: columns, alignment: .center, spacing: 10, content: {
                    ForEach(homeTimelineViewModel.userTweetData.indices, id:\.self) { index in
                        GridImageView(homeTimelineViewModel: homeTimelineViewModel, index: index)
                    }
                })
                .padding(.top)
            }
            
            //            if let link = homeTimelineViewModel.fetchLink(tweet: tweet) {
            //                LinkPreview(link: link)
            //            } else if let tweetUrl = tweet.entities.urls.first?.url, let url = URL(string: tweetUrl) {
            //                EmptyLinkPreview(url: url)
            //            }
            
            if self.isLast {
                Text("").onAppear {
                    
                    //                    Mark: Disabled for now due to api usage limit
                    //                    self.homeTimelineViewModel.fetchHomeTimeline(count: tweets.count + HomeTimelineConfig.TweetsLimit)
                }
            }
            
        }
        .overlay(
            ImageView(index: index, homeTimelineViewModel: homeTimelineViewModel)
        )
        
    }
}

struct GridImageView: View {
    @ObservedObject var homeTimelineViewModel: HomeTimelineViewModel
    var index: Int
    
    private var attachedImages: [AttachedImage] {
        return homeTimelineViewModel.userTweetData[index].attachedImages!
    }
    
    var body: some View {
        Button(action: {
            homeTimelineViewModel.selectedImageID = attachedImages[index].id
            homeTimelineViewModel.showImageViewer.toggle()
            
        }, label: {
            ZStack {
                Image(uiImage: attachedImages[index].image ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: (UIScreen.main.bounds.width - 100)/2, height: 120)
                    .cornerRadius(12)
            }
        })
    }
}

struct ImageView: View {
    let index: Int
    @ObservedObject var homeTimelineViewModel: HomeTimelineViewModel
    @GestureState var draggingOffset: CGSize = .zero
    
    private var attachedImages: [AttachedImage] {
        print("attachedImages", homeTimelineViewModel.userTweetData[index].attachedImages!.count)
        return homeTimelineViewModel.userTweetData[index].attachedImages!
    }
    
    var body: some View {
        ZStack {
            if homeTimelineViewModel.showImageViewer {
                Color(.black)
                    .opacity(homeTimelineViewModel.bgOpacity)
                    .ignoresSafeArea()
                
                ScrollView(.init()) {
                    TabView(selection: $homeTimelineViewModel.selectedImageID) {
                        ForEach(attachedImages, id: \.self) {image in
                            Image(uiImage: image.image ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tag(image)
                                .scaleEffect(homeTimelineViewModel.selectedImageID == image.id ? (homeTimelineViewModel.imageScale > 1 ? homeTimelineViewModel.imageScale : 1) : 1)
                                .offset(y: homeTimelineViewModel.imageViewerOffset.height)
                                .gesture(
                                    MagnificationGesture().onChanged({(value) in
                                        homeTimelineViewModel.imageScale = value
                                    }).onEnded({(_) in
                                        withAnimation(.spring()){
                                            homeTimelineViewModel.imageScale = 1
                                        }
                                    })
                                    
                                    .simultaneously(with: DragGesture(minimumDistance: homeTimelineViewModel.imageScale == 1 ? 1000 : 0))
                                    
                                    .simultaneously(with: TapGesture(count: 2).onEnded({
                                        withAnimation {
                                            homeTimelineViewModel.imageScale = homeTimelineViewModel.imageScale > 1 ? 1 : 4
                                        }
                                    }))
                                )
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                }
                .ignoresSafeArea()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            Button(action: {
                homeTimelineViewModel.showImageViewer.toggle()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.35))
                    .clipShape(Circle())
            })
            .padding(10)
            .opacity(homeTimelineViewModel.showImageViewer ? homeTimelineViewModel.bgOpacity : 0)
            
            , alignment: .topTrailing
        )
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


