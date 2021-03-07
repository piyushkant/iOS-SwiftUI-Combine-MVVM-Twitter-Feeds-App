//
//  HomeView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/06.
//

import SwiftUI

struct HomeTimelineView: View {
    
    @ObservedObject var homeTimelineViewModel: HomeTimelineViewModel
    
    init() {
        homeTimelineViewModel = HomeTimelineViewModel()
    }
    
    var body: some View {
        let filter = NSLocalizedString("homeTimeline", comment: "")
        
        NavigationView {
            List {
                Section(header: Text(filter).padding(.leading, -10)) {
                    let tweets: [Tweet] = self.homeTimelineViewModel.homeTimelineTweets
                    
                    ForEach(tweets) { tweet in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(tweet.text)
                                .frame(minHeight: 0, maxHeight: 100)
                                .font(.title)
                            
                        }.padding()
                    }
                }.padding()
            }.onAppear {
                homeTimelineViewModel.fetchHomeTimeline(count: 10)
            }
            
        }.navigationBarBackButtonHidden(true)
    }
}
