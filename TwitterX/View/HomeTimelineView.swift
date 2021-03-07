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
        NavigationView {
            Text("Twitter home timeline")
                .onAppear {
                    self.homeTimelineViewModel.fetchHomeTimeline(count: 5)
                }
            
        }.navigationBarBackButtonHidden(true)
    }
}
