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
    
    let provider = OAuthProvider(providerID: "twitter.com")
    
    func login() {
        provider.getCredentialWith(nil) { credential, error in
            guard let credential = credential, error == nil else {
                print("Error: \(error as Optional)")
                return
            }
            Auth.auth().signIn(with: credential) { authResult, error in
                guard let result = authResult else {return}
                
                //                if let profile = result.additionalUserInfo?.profile {
                //                    print(profile)
                //                }
                
                if let credential = result.credential {
                    let cred: OAuthCredential = credential as! OAuthCredential
                    
                    guard  let token = cred.accessToken, let tokenSecret = cred.secret else {
                        self.isLoggedIn = false
                        return
                    }
                    
                    print(token)
                    print(tokenSecret)
                    
                    do {
                        try Keychain.set(value: token.data(using: .utf8)!, account: KeychainConst.Token.string)
                        try Keychain.set(value: tokenSecret.data(using: .utf8)!, account: KeychainConst.TokenSecret.string)
                        
                        let user = try Keychain.get(account: KeychainConst.Token.string)
                        let pass = try Keychain.get(account: KeychainConst.TokenSecret.string)
                        
                        print(String(decoding: user!, as: UTF8.self))
                        print(String(decoding: pass!, as: UTF8.self))
                    } catch {
                        
                    }
                    
                    
                    self.isLoggedIn = true
                }
            }
        }
    }
}
