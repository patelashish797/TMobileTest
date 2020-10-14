//
//  FeedModel.swift
//  TMobileTest
//
//  Created by Ashish Patel on 10/14/20.
//

import Foundation

// MARK: FeedList
struct FeedList: Decodable {
    let kind: String
    let data: WelcomeData
}

struct WelcomeData: Decodable {
    let modhash: String
    let dist: Int
    let children: [Child]
    let after: String
    let before: String?
}

struct Child: Decodable {
    let kind: String
    let data: ChildData
}

struct ChildData: Decodable {
    let title: String
    let thumbnailHeight: Int?
    let thumbnailWidth: Int?
    let thumbnailURL: String
    let numOfComments: Int?
    let score: Int?
    private enum CodingKeys: String, CodingKey {
        case title, score
        case thumbnailURL = "thumbnail"
        case thumbnailHeight = "thumbnail_height"
        case thumbnailWidth = "thumbnail_width"
        case numOfComments = "num_comments"
    }
}
