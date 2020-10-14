//
//  APIError.swift
//  TMobileTest
//
//  Created by Ashish Patel on 10/14/20.
//

import Foundation

enum APIError: LocalizedError, Equatable {
    case urlError
    case parshingEror
    case dataIsNil
    case failedRequest(description: String)
    case networkConnecetionEror
    
    var errorDescription: String? {
        switch self {
        case .failedRequest(let description):
            return description
        case .parshingEror, .dataIsNil, .urlError:
            return "something went wrong, try again later."
        case .networkConnecetionEror:
            return "No Internet Connection."
        }
    }
}
