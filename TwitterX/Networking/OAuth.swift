//
//  OAuth.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import Foundation

enum OAuthConst  {
    case Version
    case SignatureMethod
    case ConsumerKey
    case ConsumerSecret
    case Token
    case TokenSecret
    case Timestamp
    case Nonce
    case Signature
    
    var string : String {
        switch self {
        case .Version: return "oauth_version"
        case .SignatureMethod: return "oauth_signature_method"
        case .ConsumerKey: return "oauth_consumer_key"
        case .ConsumerSecret: return "oauth_consumer_secret"
        case .Token: return "oauth_token"
        case .TokenSecret: return "oauth_token_secret"
        case .Timestamp: return "oauth_timestamp"
        case .Nonce: return "oauth_nonce"
        case .Signature: return "oauth_signature"
        }
    }
}

struct OAuth {
    static let version = "1.0"
    static let signatureMethod = "HMAC-SHA1"
    static let consumerKey = ProprtyUtils.getValue(fileName: "OAuth-Info", key: OAuthConst.ConsumerKey.string)
    static let consumerSecret = ProprtyUtils.getValue(fileName: "OAuth-Info", key: OAuthConst.ConsumerSecret.string)
    static let token = ""
    static let tokenSecret = ""
    
    private func authorizationHeader(for method: HTTPMethodType, url: URL, parameters: [String: Any], isMediaUpload: Bool) -> String {
        var authorizationParameters = [String: Any]()
        authorizationParameters[OAuthConst.Version.string] = OAuth.version
        authorizationParameters[OAuthConst.SignatureMethod.string] =  OAuth.signatureMethod
        authorizationParameters[OAuthConst.ConsumerKey.string] = OAuth.consumerKey
        authorizationParameters[OAuthConst.Timestamp.string] = String(Int(Date().timeIntervalSince1970))
        authorizationParameters[OAuthConst.Nonce.string] = UUID().uuidString
        authorizationParameters[OAuthConst.Token.string] = OAuth.token
        
        for (key, value) in parameters where key.hasPrefix("oauth_") {
            authorizationParameters.updateValue(value, forKey: key)
        }
        
        let combinedParameters = authorizationParameters +| parameters
        
        let finalParameters = isMediaUpload ? authorizationParameters : combinedParameters
        
        authorizationParameters[OAuthConst.Signature.string] = oauthSignature(for: method, url: url, parameters: finalParameters, consumerSecret: OAuth.consumerSecret, tokenSecret: OAuth.tokenSecret)
        
        let authorizationParameterComponents = authorizationParameters.urlEncodedQueryString(using: .utf8).components(separatedBy: "&").sorted()
        
        var headerComponents = [String]()
        for component in authorizationParameterComponents {
            let subcomponent = component.components(separatedBy: "=")
            if subcomponent.count == 2 {
                headerComponents.append("\(subcomponent[0])=\"\(subcomponent[1])\"")
            }
        }
        
        return "OAuth " + headerComponents.joined(separator: ", ")
    }
    
    private func oauthSignature(for method: HTTPMethodType, url: URL, parameters: [String: Any], consumerSecret: String, tokenSecret: String) -> String {
        let encodedConsumerSecret = consumerSecret.urlEncodedString()
        let tokenSecret = tokenSecret.urlEncodedString()
        let signingKey = "\(encodedConsumerSecret)&\(tokenSecret)"
        let parameterComponents = parameters.urlEncodedQueryString(using: .utf8).components(separatedBy: "&").sorted()
        let parameterString = parameterComponents.joined(separator: "&")
        let encodedParameterString = parameterString.urlEncodedString()
        let encodedURL = url.absoluteString.urlEncodedString()
        let signatureBaseString = "\(method)&\(encodedURL)&\(encodedParameterString)"
        
        let key = signingKey.data(using: .utf8)!
        let msg = signatureBaseString.data(using: .utf8)!
        let sha1 = HMAC.sha1(key: key, message: msg)!
        return sha1.base64EncodedString(options: [])
    }
}

infix operator +|

func +| <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>) -> Dictionary<K,V> {
    var map = Dictionary<K,V>()
    for (k, v) in left {
        map[k] = v
    }
    for (k, v) in right {
        map[k] = v
    }
    return map
}


