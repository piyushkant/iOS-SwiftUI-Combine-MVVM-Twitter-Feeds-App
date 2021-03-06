//
//  HomeView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/06.
//

import SwiftUI

struct HomeView: View {
    
    @State var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            if isLoggedIn {
                TimeLineView()
            } else {
                LoginView()
            }
        }
    }
}
