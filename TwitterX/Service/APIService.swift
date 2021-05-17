//
//  Api.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import Combine
import SwiftUI

struct APIService {
    private let oauth: OAuthService
    private let decoder = JSONDecoder()
    
    init(oauth: OAuthService) {
        self.oauth = oauth
    }
    
    //Mark: API - Home Timeline
    func homeTimeline(count: Int) -> AnyPublisher<[Tweet], ApiError> {
        var urlComponents = URLComponents(string: EndPoint.homeTimeline.url.absoluteString)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "count", value: "\(count)")
        ]
        
        let url = urlComponents.url!
        
        var request =  URLRequest(url: url)
        request.httpMethod = "GET"
        
        let header = oauth.authorizationHeader(for: .GET, url: EndPoint.homeTimeline.url, parameters: ["count" : count], isMediaUpload: false)
        request.addValue(header, forHTTPHeaderField: "Authorization")
        
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw ApiError.invalidResponse
                }
                return data
            }
            .decode(type: [Tweet].self, decoder: decoder)
            .mapError { error in
                switch error {
                case is URLError:
                    return ApiError.addressUnreachable(url)
                default: return ApiError.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    //Mark: API - Show
    func show(id: String) -> AnyPublisher<Tweet, ApiError> {
        var urlComponents = URLComponents(string: EndPoint.showTweet.url.absoluteString)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: "\(id)")
        ]
        
        let url = urlComponents.url!
        
        var request =  URLRequest(url: url)
        request.httpMethod = "GET"
        
        let header = oauth.authorizationHeader(for: .GET, url: EndPoint.showTweet.url, parameters: ["id" : id], isMediaUpload: false)
        request.addValue(header, forHTTPHeaderField: "Authorization")
        
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw ApiError.invalidResponse
                }
                return data
            }
            .decode(type: Tweet.self, decoder: decoder)
            .mapError { error in
                switch error {
                case is URLError:
                    return ApiError.addressUnreachable(url)
                default: return ApiError.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    //Mark: API - Destroy
    func destroy(id: String) -> AnyPublisher<Tweet, ApiError> {
        var urlComponents = URLComponents(string: EndPoint.deleteTweet.url.absoluteString)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: "\(id)")
        ]
        
        let url = urlComponents.url!
        
        var request =  URLRequest(url: url)
        request.httpMethod = "POSt"
        
        let header = oauth.authorizationHeader(for: .POST, url: EndPoint.deleteTweet.url, parameters: ["id" : id], isMediaUpload: false)
        request.addValue(header, forHTTPHeaderField: "Authorization")
        
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw ApiError.invalidResponse
                }
                return data
            }
            .decode(type: Tweet.self, decoder: decoder)
            .mapError { error in
                switch error {
                case is URLError:
                    return ApiError.addressUnreachable(url)
                default: return ApiError.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    //Mark: API - Settings
    func settings() -> AnyPublisher<Settings, ApiError> {
        let url = URL(string: EndPoint.accountSettings.url.absoluteString)!
        
        var request =  URLRequest(url: url)
        request.httpMethod = "GET"
        
        let header = oauth.authorizationHeader(for: .GET, url: EndPoint.accountSettings.url, parameters: [:], isMediaUpload: false)
        request.addValue(header, forHTTPHeaderField: "Authorization")
        
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw ApiError.invalidResponse
                }
                return data
            }
            .decode(type: Settings.self, decoder: decoder)
            .mapError { error in
                switch error {
                case is URLError:
                    return ApiError.addressUnreachable(url)
                default: return ApiError.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    //Mark: API - Unfollow
    func unfollowUser(id: String) -> AnyPublisher<User, ApiError> {
        var urlComponents = URLComponents(string: EndPoint.unfollowUser.url.absoluteString)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: "\(id)")
        ]
        
        let url = urlComponents.url!
        
        var request =  URLRequest(url: url)
        request.httpMethod = "POSt"
        
        let header = oauth.authorizationHeader(for: .POST, url: EndPoint.unfollowUser.url, parameters: ["user_id":id], isMediaUpload: false)
        request.addValue(header, forHTTPHeaderField: "Authorization")
                
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw ApiError.invalidResponse
                }
                return data
            }
            .decode(type: User.self, decoder: decoder)
            .mapError { error in
                switch error {
                case is URLError:
                    return ApiError.addressUnreachable(url)
                default: return ApiError.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
}
