//
//  OAuth.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import Foundation
import Firebase

enum OauthProvider  {
    case Twitter
    
    var id : String {
        switch self {
        case .Twitter: return "twitter.com"
        }
    }
}

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

enum OAuthCredentialResult {
    case success (OAuthCredential)
    case failure ([String: String])
}

struct OAuthService {
    var version: String {
        get {
            return "1.0"
        }
    }
    
    var signatureMethod: String {
        get {
            return "HMAC-SHA1"
        }
    }
    
    var consumerKey: String {
        get {
            return ProprtyUtils.getValue(fileName: "OAuth-Info", key: OAuthConst.ConsumerKey.string)
        }
    }
    
    var consumerSecret: String {
        get {
            return ProprtyUtils.getValue(fileName: "OAuth-Info", key: OAuthConst.ConsumerSecret.string)
        }
    }
    
    var token: String? {
        get {
            do {
                let tokenData = try Keychain.get(key: KeychainConst.Token.string)
                
                guard let data = tokenData else {return nil}
                
                return String(decoding: data, as: UTF8.self)
            } catch let error {
                print(error)
                return nil
            }
        }
    }
    
    var tokenSecret: String? {
        get {
            do {
                let tokenSecretData = try Keychain.get(key: KeychainConst.TokenSecret.string)
                
                guard let data = tokenSecretData else {return nil}
                
                return String(decoding: data, as: UTF8.self)
            } catch let error {
                print(error)
                return nil
            }
        }
    }
    
    func authorizationHeader(for method: HTTPMethodType, url: URL, parameters: [String: Any], isMediaUpload: Bool) -> String {
        guard let token = token, let tokenSecret = tokenSecret else {return ""}
        
        var authorizationParameters = [String: Any]()
        authorizationParameters[OAuthConst.Version.string] = version
        authorizationParameters[OAuthConst.SignatureMethod.string] =  signatureMethod
        authorizationParameters[OAuthConst.ConsumerKey.string] = consumerKey
        authorizationParameters[OAuthConst.Timestamp.string] = String(Int(Date().timeIntervalSince1970))
        authorizationParameters[OAuthConst.Nonce.string] = UUID().uuidString
        authorizationParameters[OAuthConst.Token.string] = token
        
        for (key, value) in parameters where key.hasPrefix("oauth_") {
            authorizationParameters.updateValue(value, forKey: key)
        }
        
        let combinedParameters = authorizationParameters +| parameters
        
        let finalParameters = isMediaUpload ? authorizationParameters : combinedParameters
        
        authorizationParameters[OAuthConst.Signature.string] = oauthSignature(for: method, url: url, parameters: finalParameters, consumerSecret: consumerSecret, tokenSecret: tokenSecret)
        
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
    
    let provider = OAuthProvider(providerID: OauthProvider.Twitter.id)
    
    func signIn(completionHandler: @escaping (OAuthCredentialResult) -> ()) {
        provider.getCredentialWith(nil) { credential, error in
            guard let credential = credential, error == nil else {
                completionHandler(.failure(["message" : "Error: \(error as Optional)"]))
                return
            }
            
            Auth.auth().signIn(with: credential) { result, error in
                if let result = result, let credential = result.credential, let oauthCredential = credential as? OAuthCredential {
                    completionHandler(.success(oauthCredential))
                } else {
                    completionHandler(.failure(["message" : "Error: Failed to get OAuth Credential"]))
                }
            }
        }
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


