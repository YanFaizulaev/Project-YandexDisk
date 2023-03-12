//
//  SecondViewController.swift
//  Skillbox Drive
//
//  Created by Bandit on 19.01.2023.
//

import UIKit

final class SecondViewController: TableViewControllerDefault {
    
    // MARK: - Model
    
    private var filesData = LastFilesClass()
    private let serviceAPI = APILastUploaded()
    
    // MARK: - Label
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Constans.Fonts.graphik15
        label.text = Constans.Text.allFilesOnbordingLabel
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let fileCellIndentifier = "FileTableViewCell"
    
    // MARK: - LoadView
    override func loadView() {
        super.loadView()
        
        let margins = view.safeAreaLayoutGuide
        
        self.view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        
        self.label.isHidden = true
        self.tableView.isHidden = true
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        title = Constans.Text.lastTitleLabel
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FileTableViewCell.self, forCellReuseIdentifier: fileCellIndentifier)
        }
    
    internal override func updateData () {
        activityIndicator.startAnimating()
        serviceAPI.fetchLastUploaded(limit) { result in
            switch result {
            case .success(let response):
                print("Last files: \(response.items.count )")
                
                var model : [Items] = []
                for item in response.items {
                    model.append(Items(name: item?.name,
                                       preview: item?.preview,
                                       created: item?.created,
                                       modified: item?.modified,
                                       path: item?.path,
                                       type: item?.type,
                                       mime_type: item?.mime_type,
                                       size: item?.size,
                                       file: item?.file))

                }
                
                self.filesData.saveToCoreData(array: model)
                self.filesData.seveData()
                
                self.tableView.reloadData()
                self.isMoreDataLoading = false
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                UtilsShowAlert.showAlertErrorNoInternet(viewcontroller: self)
                print("Error loading recommended podcasts: \(error.localizedDescription)")
                self.activityIndicator.stopAnimating()
            }
            
            if self.filesData.connectContext().count == 0 {
                self.label.isHidden = false
            } else {
                self.tableView.isHidden = false
            }
        }
    }
}

extension SecondViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filesData.connectContext().count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let files = filesData.connectContext()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: fileCellIndentifier) as? FileTableViewCell
        
        cell?.configure(files)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PresentViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.file = filesData.connectContext()[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
}
