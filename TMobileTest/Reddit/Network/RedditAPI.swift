//
//  RedditAPI.swift
//  TMobileTest
//
//  Created by Ashish Patel on 10/14/20.
//

import Foundation

class RedditAPI {
    private let urlSession: URLSession
    private let queryItems: [String: String]?

    //https://www.reddit.com/.json
    var component: URLComponents = {
        var componet = URLComponents()
        componet.scheme = "https"
        componet.host = "www.reddit.com"
        componet.path = "/.json"
        return componet
    }()
        
    init(queryItems: [String: String]?, urlSession: URLSession = .shared) {
        self.queryItems = queryItems
        self.urlSession = urlSession
    }

    func fetchFeedList(onCompition: @escaping (Result<FeedList, APIError>) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            onCompition(.failure(.networkConnecetionEror))
        }
        if let queryItems = queryItems {
            component.queryItems = queryItems.map({ (key, value) in
                URLQueryItem(name: key, value: value)
            })
        }

        guard let url = component.url else {
            onCompition(.failure(.urlError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                print("data is nil")
                onCompition(.failure(.dataIsNil))
                return
            }
            if let feedList = try? JSONDecoder().decode(FeedList.self, from: data) {
                onCompition(.success(feedList))
            } else {
                onCompition(.failure(.parshingEror))
                print("error in json parsing")
            }
        }
        task.resume()
    }
}
