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
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { (geometry: GeometryProxy) in
                if geometry.frame(in: .global).minY <= 0 {
                    Image("img4").resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width,
                               height: geometry.size.height)
                }
                else {
                    Image("img4").resizable()
                        .aspectRatio(contentMode: .fill)
                        .offset(y: -geometry.frame(in: .global).minY)
                        .frame(width: geometry.size.width,
                               height: geometry.size.height
                                + geometry.frame(in: .global).minY)
                }
            }
            .frame(maxHeight: kHeaderHeight)
            
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
            
            Text(tweet.user.description)
                .bold()
                .font(.system(size:16.0))
                .padding(.leading)
            
            HyperlinkTextView("http://www.piyushkant.com")
                .font(.system(size:13.0))
                .padding(.leading)
                .padding(.vertical, 0.1)
            
            HStack(spacing: 20) {
                Text("0 Followers")
                    .bold()
                    .font(.system(size:16.0))
                    .padding(.leading)
                    .foregroundColor(Color.gray)
                Text("0 Following")
                    .bold()
                    .font(.system(size:16.0))
                    .foregroundColor(Color.gray)
            }
        }
    }
}
