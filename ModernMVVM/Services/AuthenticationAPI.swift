//
//  AuthenticationAPI.swift
//  ModernMVVM
//
//  Created by somineni on 5/8/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation
import Combine

extension API {
    static func login(bodyParams:[String:CustomStringConvertible]) -> AnyPublisher<LoginResponseObject, Error> {
        let url = base.appendingPathComponent(APIPath.login.route())
        let resource = NetworkRequest(url, [:],.POST , bodyParams)
        return apiCall.run(resource.request!)
    }
    static func signUp(bodyParams:[String:CustomStringConvertible]) -> AnyPublisher<SignUpResponseObject, Error> {
        let url = base.appendingPathComponent(APIPath.register.route())
        let resource = NetworkRequest(url, [:],.POST , bodyParams)
        return apiCall.run(resource.request!)
    }
    static func resetPassword(bodyParams:[String:CustomStringConvertible]) -> AnyPublisher<SignUpResponseObject, Error> {
           let url = base.appendingPathComponent(APIPath.resetPassword.route())
           let resource = NetworkRequest(url, [:],.POST , bodyParams)
           return apiCall.run(resource.request!)
    }
}

// MARK: - Login DTOs
struct LoginResponseObject: Codable {
    let id:String?
    let token:String?
    let role:String?
    let message:String?
}

struct SignUpResponseObject: Codable {
    let status:Bool?
    let message:String?
}
