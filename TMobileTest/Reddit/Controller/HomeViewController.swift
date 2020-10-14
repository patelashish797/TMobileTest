//
//  HomeViewController.swift
//  TMobileTest
//
//  Created by Ashish Patel on 10/14/20.
//

import UIKit

final class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AlertDisplayer {
    
    private var viewModel: FeedViewModel!
    private var loadingStatus = false
    var safeArea: UILayoutGuide!
    
    lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorInset = .zero
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FeedViewModel(delegate: self)
        viewModel.fetchFeeds()
        self.navigationItem.title = "Reddit"
        safeArea = view.layoutMarginsGuide
        steupViews()
    }
    
    func steupViews() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FeedCell.self, forCellReuseIdentifier: "FeedCell")
        self.tableView.tableFooterView = createSpinnerFooter()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell else {
            return UITableViewCell()
        }
        cell.populate(with: viewModel.dataAtIndex(index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellHeight = viewModel.heightOfCell(at: indexPath.row) else { return UITableView.automaticDimension }
        return cellHeight
    }
        
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.currentCount - 1 {
            if !viewModel.isFetchInProgress {
                viewModel.fetchFeeds()
                self.tableView.tableFooterView = createSpinnerFooter()
            }
        }
    }
    
    // MARK: - Helper Functions
    func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }

}

// MARK: - FeedViewModelDelegate Extension
extension HomeViewController: FeedViewModelDelegate {
    
    func onFetchCompleted() {
        self.tableView.reloadData()
        self.tableView.tableFooterView = nil
    }
    
    func onFetchFailed(with reason: String) {
        let title = "Error"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title, message: reason, actions: [action])
    }
    
}
