//
//  UserInfoView+PostTimeView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/17.
//

import SwiftUI

struct UserInfoView: View {
    @ObservedObject var homeViewModel: HomeViewModel
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
            
//            HStack {
//                Spacer()
//                VStack {
//                    HStack {
//                        Spacer()
//                        OptionActionSheetView(homeViewModel: homeViewModel, tweet: tweet)
//                    }
//                    Spacer()
//                }
//            }
        .onReceive(timer) {
            self.currentDate = $0
//            homeViewModel.fetchHomeTimeline(count: HomeConfig.TweetsLimit)
        }
    }
}

struct OptionActionSheetView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    let tweet: Tweet
    @State private var showingActionSheet = false
    
    var body: some View {
        Button(action: {
            self.showingActionSheet = true
        }, label: {
            Image("option")
        })
        .actionSheet(isPresented: $showingActionSheet) { () -> ActionSheet in
            ActionSheet(title: Text("Options"), message: Text("Choose right option"), buttons:
                            [
                                .default(Text("Delete Tweet")) {
                                    homeViewModel.destroy(id: tweet.idStr)
                                },
                                .cancel()
                            ]
            )
        }
    }}
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
