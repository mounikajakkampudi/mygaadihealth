//
//  Constants.swift
//  ModernMVVM
//
//  Created by somineni on 5/8/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation
import SwiftUI

struct Constants {
    static let baseURL = "http://localhost:8082/apis/v1.0/"
    //static let baseURL = "http://ec2-54-162-162-95.compute-1.amazonaws.com:8082/apis/v1.0/"
    static let imageBaseURL = "http://ec2-54-162-162-95.compute-1.amazonaws.com:8082"
    static let apiKey = "efb6cac7ab6a05e4522f6b4d1ad0fa43"
    static let appColor = Color(red: 204.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, opacity: 1.0)
    static let deviceWidth = UIScreen.main.bounds.width
    static let deviceHeight = UIScreen.main.bounds.height
}
