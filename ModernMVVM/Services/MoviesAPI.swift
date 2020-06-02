//
//  MoviesAPI.swift
//  ModernMVVM
//
//  Created by Vadym Bulavin on 2/20/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation
import Combine

extension API {
    static func trending() -> AnyPublisher<MovieDTO, Error> {
        
        let request = URLComponents(url: base.appendingPathComponent(APIPath.organizationsList.route()), resolvingAgainstBaseURL: true)?
            .addingApiKey(apiKey)
            .request
        return apiCall.run(request!)
    }
    
    static func movieDetail(id: Int) -> AnyPublisher<MovieDTO, Error> {
        let request = URLComponents(url: base.appendingPathComponent("organizations/\(id)"), resolvingAgainstBaseURL: true)?
            .addingApiKey(apiKey)
            .request
        return apiCall.run(request!)
    }
}

// MARK: - DTOs

struct MovieDTO: Codable {
     let id: String
     let name: String
     let industry: String
     let address: String
     let thumb_url:String
}

struct MovieDetailDTO: Codable {
    let id: Int
    let title: String
    let overview: String?
    let poster_path: String?
    let vote_average: Double?
    let genres: [GenreDTO]
    let release_date: String?
    let runtime: Int?
    let spoken_languages: [LanguageDTO]
    
    var poster: URL? { poster_path.map { API.imageBase.appendingPathComponent($0) } }
    
    struct GenreDTO: Codable {
        let id: Int
        let name: String
    }
    
    struct LanguageDTO: Codable {
        let name: String
    }
}

struct PageDTO<T: Codable>: Codable {
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    let results: [T]
}
