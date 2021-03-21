//
//  KeychainConst.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import Foundation

enum KeychainConst  {
    case Token
    case TokenSecret
    case ScreenName
        
    var string : String {
        switch self {
        case .Token: return "keychain_token"
        case .TokenSecret: return "keychain_token_secret"
        case .ScreenName: return "keychain_screen_name"
        }
    }
}
