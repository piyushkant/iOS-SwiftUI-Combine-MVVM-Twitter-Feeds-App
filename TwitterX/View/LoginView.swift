//
//  LoginView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/06.
//

import SwiftUI

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0)
let twitterColor = Color(red: 29.0/255.0, green: 161/255.0, blue: 242.0/255.0)

struct LoginView: View {
    
    @ObservedObject var loginViewModel: LoginViewModel
    
    init() {
        loginViewModel = LoginViewModel(oauth: OAuth())
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HelloText()
                LoginImage()

                NavigationLink(destination: HomeTimelineView(), isActive: $loginViewModel.isLoggedIn) { EmptyView() }

                
                Button(action: {
                    loginViewModel.login()
                }) {
                    LoginButtonContent()
                }
            }
        }
    }
}

struct HelloText: View {
    var body: some View {
        Text(NSLocalizedString("twitterx", comment: ""))
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
            .foregroundColor(twitterColor)
    }
}

struct LoginImage: View {
    var body: some View {
        Image("LoginImage")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 75)
        
    }
}

struct LoginButtonContent: View {
    var body: some View {
        Text(NSLocalizedString("login", comment: ""))
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(twitterColor)
            .cornerRadius(35.0)
    }
}

