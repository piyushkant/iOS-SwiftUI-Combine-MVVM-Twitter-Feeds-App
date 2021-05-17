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
    private var subscriptions = Set<AnyCancellable>()
    let oauth: OAuthService
    
    @Published var isLoggedIn = false
    @Published var error: ApiError? = nil

    init(oauth: OAuthService) {
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
                    
                    self.fetchSettings()
                } catch let error {
                    print(error)
                }
                
            case let .failure(error):
                print(error)
            }
        })
    }
    
    func fetchSettings() {
        let api = APIService(oauth: self.oauth)
        api
            .settings()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
            }, receiveValue: { settings in
                do {
                    try Keychain.set(value: settings.screenName.data(using: .utf8)!, key: KeychainConst.ScreenName.string)
                } catch let error {
                    print(error)
                }
                
                self.error = nil
            })
            .store(in: &subscriptions)
    }
}
