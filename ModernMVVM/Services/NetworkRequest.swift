//
//  NetworkRequest.swift
//  ModernMVVM
//
//  Created by somineni on 5/8/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation
struct NetworkRequest {
    let url: URL
    let parameters: [String: CustomStringConvertible]
    let method:APIMethod
    let bodyParams: [String: CustomStringConvertible]
    var request: URLRequest? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.queryItems = parameters.keys.map { key in
            URLQueryItem(name: key, value: parameters[key]?.description)
        }
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("dev", forHTTPHeaderField: "token")

        if method != .GET {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyParams, options: JSONSerialization.WritingOptions())
                
            } catch _ {
                print ("Oops something happened buddy")
            }
        }
        return request
    }

    init(_ url: URL, _ parameters: [String: CustomStringConvertible] = [:], _ method:APIMethod = .GET, _ bodyParams:[String: CustomStringConvertible] = [:]) {
        self.url = url
        self.parameters = parameters
        self.method = method
        self.bodyParams = bodyParams
    }
}


enum APIMethod:String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

enum APIPath {
    case login
    case register
    case organizationsList
    case resetPassword
    case addReview
    func route() -> String {
        switch self {
        case .login:
            return "login"
        case .register:
            return "register"
        case .organizationsList:
            return "organizations"
        case .resetPassword:
            return "password/recovery"
        case .addReview:
            return "addReview"
        }
    }
}
