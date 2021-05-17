//
//  LogoutView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/05/17.
//

import SwiftUI

struct LogoutView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    @State private var showingActionSheet = false
    
    var body: some View {
        Button(action: {
            self.showingActionSheet = true
        }, label: {
            Image("Logout")
        })
        .actionSheet(isPresented: $showingActionSheet) { () -> ActionSheet in
            ActionSheet(title: Text("Log Out current user"), message: Text(""), buttons:
                            [
                                .default(Text("Log Out")) {
                                    print("logging out...")
                                },
                                .cancel()
                            ]
            )
        }
    }}
