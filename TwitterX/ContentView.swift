//
//  ContentView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/06.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    
    init() {
        loginViewModel = LoginViewModel()
    }
    
    var body: some View {
        LoginView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
