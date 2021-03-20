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
           
            Button(action: {
                print("button", "Clicked option button!")
                homeViewModel.destroy(id: tweet.idStr)
                
            }, label: {
                Image("option2")
                    .padding(.bottom)
            })
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
