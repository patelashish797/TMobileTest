//
//  AlertDisplayer.swift
//  TMobileTest
//
//  Created by Ashish Patel on 10/14/20.
//

import UIKit

protocol AlertDisplayer {
    func displayAlert(with title: String, message: String, actions: [UIAlertAction]?)
}

extension AlertDisplayer where Self: UIViewController {
    func displayAlert(with title: String, message: String, actions: [UIAlertAction]? = nil) {
        DispatchQueue.main.async {
            guard self.presentedViewController == nil else {
                return
            }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            actions?.forEach { action in
                alertController.addAction(action)
            }
            self.present(alertController, animated: true)
        }
    }
}
