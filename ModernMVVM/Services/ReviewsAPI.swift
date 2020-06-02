//
//  ReviewsAPI.swift
//  ModernMVVM
//
//  Created by Mounika Jakkampudi on 5/26/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation
import Combine

extension API {
   static func addReview(bodyParams:[String:CustomStringConvertible]) -> AnyPublisher<SignUpResponseObject, Error> {
        let url = base.appendingPathComponent(APIPath.addReview.route())
        let resource = NetworkRequest(url, [:],.POST , bodyParams)
        return apiCall.run(resource.request!)
    }
}

// MARK: Review DTO
struct ReviewDTO: Codable {
    let id: String
    let name: String
    let industry: String
    let address: String
    let thumb_url: String
    let reviews: [ReviewsDTO]?
}


