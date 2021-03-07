//
//  Api.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import Combine
import SwiftUI

struct Api {
    private let oauth: OAuth
    private let decoder = JSONDecoder()
    
    init(oauth: OAuth) {
        self.oauth = oauth
    }
    
    func homeTimeline(count: Int) -> AnyPublisher<[Tweet], ApiError> {
        var urlComponents = URLComponents(string: EndPoint.Statuses.homeTimeline.url.absoluteString)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "count", value: "\(count)")
        ]
        
        let url = urlComponents.url!
                
        var request =  URLRequest(url: url)
        request.httpMethod = "GET"
        
        let header = oauth.authorizationHeader(for: .GET, url: EndPoint.Statuses.homeTimeline.url, parameters: ["count" : count], isMediaUpload: false)
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
    
}
