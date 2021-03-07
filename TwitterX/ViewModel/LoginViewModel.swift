//
//  LoginViewModel.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/06.
//

import SwiftUI
import Combine
import Firebase

class LoginViewModel: ObservableObject {
    @Published var isLoggedIn = false
    
    let oauth: OAuth
    
    init(oauth: OAuth) {
        self.oauth = oauth
    }
    
    func login() {
        self.isLoggedIn = false
        
        oauth.signIn(completionHandler: { (result) in
            switch (result) {
            case let .success(oauthCredential):
                guard let token = oauthCredential.accessToken, let tokenSecret = oauthCredential.secret else {
                    return
                }
                
                do {
                    try Keychain.set(value: token.data(using: .utf8)!, key: KeychainConst.Token.string)
                    try Keychain.set(value: tokenSecret.data(using: .utf8)!, key: KeychainConst.TokenSecret.string)
                    
                    self.isLoggedIn = true
                } catch let error {
                    print(error)
                }
                
            case let .failure(error):
                print(error)
            }
        })
    }
}
