//
//  ProfileView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/21.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    let tweet: Tweet
    private let kHeaderHeight: CGFloat = 0
    
    var screenName: String? {
        get {
            do {
                let screenNamedata = try Keychain.get(key: KeychainConst.ScreenName.string)
                
                guard let data = screenNamedata else {return nil}
                
                return String(decoding: data, as: UTF8.self)
            } catch let error {
                print(error)
                return nil
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if let profileBannerData = homeViewModel.fetchUserProfileBannerData(tweet: tweet), let data = profileBannerData.data {
//                GeometryReader { (geometry: GeometryProxy) in
//                    if geometry.frame(in: .global).minY <= 0 {
//                        Image(uiImage: UIImage(data: data) ?? UIImage())
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: geometry.size.width,
//                                   height: geometry.size.height)
//                    }
//                    else {
//                        Image(uiImage: UIImage(data: data) ?? UIImage())
//                            .aspectRatio(contentMode: .fill)
//                            .offset(y: -geometry.frame(in: .global).minY)
//                            .frame(width: geometry.size.width,
//                                   height: geometry.size.height
//                                    + geometry.frame(in: .global).minY)
//                    }
//                }
//                .frame(maxHeight: kHeaderHeight)
                Image(uiImage: UIImage(data: data) ?? UIImage())
            }
            
            HStack(spacing: 10) {
                if let userInfoData = homeViewModel.fetchUserData(tweet: self.tweet), let data = userInfoData.profileImageData {
                    Image(uiImage: UIImage(data: data) ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:50, height:50)
                        .cornerRadius(50)
                        .padding(.leading)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(tweet.user.name)
                        .bold()
                        .font(.system(size:18.0))
                    
                    Text("@"+tweet.user.screenName)
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                }
            }
            
            HyperlinkTextView(tweet.user.description)
                .padding(.leading)
            
            if let userUrl = tweet.user.entities.url, let profileUrl = userUrl.urls.first, let url = profileUrl.displayUrl {
                HyperlinkTextView(url)
                    .padding(.leading)
                    .padding(.vertical, 0.1)
            }
            
            HStack(spacing: 20) {
                Text("\(tweet.user.followersCount) \(NSLocalizedString("followers", comment: ""))")
                    .bold()
                    .font(.system(size:16.0))
                    .padding(.leading)
                    .foregroundColor(Color.gray)
                Text("\(tweet.user.friendsCount) \(NSLocalizedString("following", comment: ""))")
                    .bold()
                    .font(.system(size:16.0))
                    .foregroundColor(Color.gray)
            }
            
            if let screenName = self.screenName, screenName != tweet.user.screenName {
                Button(action: {
                    
                }) {
                    Text(tweet.user.following ? NSLocalizedString("unfollow", comment: "") : NSLocalizedString("follow", comment: ""))
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 40)
                        .background(tweet.user.following ? Color.red : twitterColor)
                        .cornerRadius(35.0)
                        .padding()
                }
            }
        }
    }
}
