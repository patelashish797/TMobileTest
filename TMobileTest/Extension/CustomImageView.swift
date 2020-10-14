//
//  CustomImageView.swift
//  TMobileTest
//
//  Created by Ashish Patel on 10/14/20.
//

import UIKit

class CustomImageView: UIImageView {
    
    var task: URLSessionDataTask!
    let imageCache = NSCache<NSObject, NSObject>()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    func downloadImageFrom(imageURL: URL) {
        addSpiner()
        image = nil
        if let task = task {
            task.cancel()
        }
        if let imageFromCache = imageCache.object(forKey: imageURL.absoluteString as NSObject) as? UIImage {
            image = imageFromCache
            removeSpiner()
            return
        }
        task = URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            guard let data = data, let newImage = UIImage(data: data) else {
                print("error downloading image from \(imageURL.absoluteString)")
                return
            }
            if let error = error {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.image = newImage
                self.removeSpiner()
                self.imageCache.setObject(newImage, forKey: imageURL.absoluteString as NSObject)
            }
        }
        task.resume()
    }
    
    func addSpiner() {
        self.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        spinner.startAnimating()
    }
    
    func removeSpiner() {
        spinner.removeFromSuperview()
    }
}
