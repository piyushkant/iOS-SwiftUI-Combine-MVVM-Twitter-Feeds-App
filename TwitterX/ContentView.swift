//
//  ContentView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/06.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    var body: some View {

        if isLoggedIn() {
            HomeView()
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func isLoggedIn() -> Bool {
    return Auth.auth().currentUser != nil
}
