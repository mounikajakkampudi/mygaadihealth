//
//  OrgAPI.swift
//  ModernMVVM
//
//  Created by Mounika Jakkampudi on 5/12/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation
import Combine

extension API {
    static func getOrgnizationsList() -> AnyPublisher<OrgniazationsListResponseObject<OrganizationDTO>, Error> {
        let url = base.appendingPathComponent(APIPath.organizationsList.route())
        let resource = NetworkRequest(url, [:],.GET)
        return apiCall.run(resource.request!)

    }
    
    static func getOriganizationDetail(id: Int) -> AnyPublisher<OrganizationDTO, Error> {
        let request = URLComponents(url: base.appendingPathComponent("organizations/\(id)"), resolvingAgainstBaseURL: true)?
            .addingApiKey(apiKey)
            .request
        return apiCall.run(request!)
    }
}

// MARK: Origanization DTO
struct OrganizationDTO: Codable {
    let id: String
    let name: String
    let industry: String
    let address: String
    let thumb_url: String
    let reviews: [ReviewsDTO]?
}

struct ReviewsDTO: Codable, Hashable {
    let id: String
    let message: String
    let rating: Int
    let review_source: String
}

struct OrgniazationsListResponseObject<T: Codable> : Codable {
    let results: [T]
}

