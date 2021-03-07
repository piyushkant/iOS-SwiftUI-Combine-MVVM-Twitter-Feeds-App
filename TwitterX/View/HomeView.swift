//
//  HomeView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/06.
//

import SwiftUI

struct HomeView: View {
    
    @State private var isLoggedIn = false
    let oauth: OAuth
    
    init() {
        self.oauth = OAuth()
    }
    
    var body: some View {
        NavigationView {
            Text(self.oauth.token ?? "No token in keychain")
            
        }.navigationBarBackButtonHidden(true)
    }
}
