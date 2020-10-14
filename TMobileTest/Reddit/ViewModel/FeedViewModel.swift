//
//  FeedViewModel.swift
//  TMobileTest
//
//  Created by Ashish Patel on 10/14/20.
//

import UIKit

protocol FeedViewModelDelegate: class {
    func onFetchCompleted()
    func onFetchFailed(with reason: String)
}

final class FeedViewModel {
    private weak var delegate: FeedViewModelDelegate?
    var isFetchInProgress = false
    var child = [Child]()
    var afterLink: String?
    
    init(delegate: FeedViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: FeedViewModel Helper Function
    func fetchFeeds() {
        var queryItem: [String: String]?
        if let afterLink = afterLink {
            queryItem = ["after": afterLink]
        }
        isFetchInProgress = true
        
        RedditAPI.init(queryItems: queryItem).fetchFeedList {[weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.child.append(contentsOf: data.data.children)
                self.afterLink = data.data.after
                self.isFetchInProgress = false
                DispatchQueue.main.async {
                    self.delegate?.onFetchCompleted()
                }
            case .failure(let error):
                self.isFetchInProgress = false
                self.delegate?.onFetchFailed(with: error.localizedDescription)
                print("error \(error)")
            }
        }
    }
    
    func heightOfCell(at index: Int) -> CGFloat? {
        guard let height = child[index].data.thumbnailHeight,
              let width = child[index].data.thumbnailWidth,
              thumbnailURLAtIndex(index: index) != nil else { return nil }
        let ratio = CGFloat(width)/CGFloat(height)
        let heightOfTitle = child[index].data.title.height(withConstrainedWidth: UIScreen.main.bounds.width,
                                                           font: UIFont.boldSystemFont(ofSize: 16))
        let heightOfSubtitle = "score".height(withConstrainedWidth: UIScreen.main.bounds.width,
                                              font: UIFont.systemFont(ofSize: 14))
        return (UIScreen.main.bounds.width / ratio) + heightOfTitle + heightOfSubtitle + 44
    }
}

// MARK: - FeedViewModel Extension
extension FeedViewModel {
    var numberOfSection: Int {
        return 1
    }
    
    var numberOfRows: Int {
        return self.child.count
    }
    
    var currentCount: Int {
        return self.child.count
    }
    
    func dataAtIndex(index: Int) -> Child {
        return self.child[index]
    }
    
    func thumbnailHeightAtIndex(index: Int) -> Int? {
        return self.child[index].data.thumbnailHeight
    }
    
    func thumbnailWidthAtIndex(index: Int) -> Int? {
        return self.child[index].data.thumbnailWidth
    }
    
    func thumbnailURLAtIndex(index: Int) -> String? {
        return self.child[index].data.thumbnailURL.isValidURL ? self.child[index].data.thumbnailURL : nil
    }
}
