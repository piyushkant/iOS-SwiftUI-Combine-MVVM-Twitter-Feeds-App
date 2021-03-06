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
                    print(cred.accessToken!)
                    print(cred.secret!)
                    self.isLoggedIn = true
                }
            }
        }
    }
}
