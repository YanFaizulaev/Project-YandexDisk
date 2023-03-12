//
//  TableViewControllerDefault.swift
//  Skillbox Drive
//
//  Created by Bandit on 17.02.2023.
//

import UIKit

public class TableViewControllerDefault: UIViewController, UIScrollViewDelegate {
    
//    var current = UIStatusBarStyle.default
    var limit: Int = 20
    var isMoreDataLoading = false
    
    // MARK: - Indicator
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .gray
        return view
    }()
    
    // MARK: - TableView and Refresh
    let refreshControl = UIRefreshControl()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.backgroundColor = .white
        view.rowHeight = 60
        view.addSubview(refreshControl)
        view.separatorStyle = .none
        return view
    }()
    
    // MARK: - LoadView
    public override func loadView() {
        super.loadView()
        
        let margins = view.safeAreaLayoutGuide
        
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicator)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
    }
    
    // MARK: - ViewDidLoad
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
//        current = .darkContent
//        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return current
//    }
    
    
    @objc func refresh(_ sender: AnyObject) {
        updateData()
        refreshControl.endRefreshing()
    }

    // MARK: - Functions
    func updateData () {
    }
    
    // MARK: - ViewDidAppear
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateData()
    }
    
    @objc public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                limit += 20
                updateData()
                print("Update TableView")
            }
        }
    }
}
