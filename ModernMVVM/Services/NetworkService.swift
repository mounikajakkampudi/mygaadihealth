//
//  Agent.swift
//  ModernMVVM
//
//  Created by Vadym Bulavin on 2/20/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation
import Combine

struct NetworkService {
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .print()
            .map { $0.data }
            .handleEvents(receiveOutput:{
                print(NSString(data: $0, encoding: String.Encoding.utf8.rawValue)!)
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


enum API  {
    static let imageBase = URL(string: Constants.imageBaseURL)!
    static let base = URL(string: Constants.baseURL)!
    static let apiKey = Constants.apiKey
    static let apiCall = NetworkService()
}

extension URLComponents {
    func addingApiKey(_ apiKey: String) -> URLComponents {
        var copy = self
        copy.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        return copy
    }
    
    var request: URLRequest? {
        url.map { URLRequest.init(url: $0) }
    }
}

extension URLRequest {
    mutating func addHeaderValues(){
        self.setValue("application/json", forHTTPHeaderField:"Content-Type")
        self.setValue("dev", forHTTPHeaderField:"token")
    }
}


