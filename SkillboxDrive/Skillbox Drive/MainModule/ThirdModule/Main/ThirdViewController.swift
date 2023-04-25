//
//  ThirdViewController.swift
//  Skillbox Drive
//
//  Created by Bandit on 20.01.2023.
//

import UIKit

class ThirdViewController: TableViewControllerDefault {
    
    var path: String? = nil
    
    private let serviceAPI = APIFullDiskResponse()
    var file: Items?
    
    private var filesData = AllFilesClass()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Constans.Fonts.graphik15
        label.text = Constans.Text.allFilesOnbordingLabel
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let fileCellIndentifier = "FileTableViewCell"
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(label)
        
        let margins = view.safeAreaLayoutGuide
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        
        self.label.isHidden = true
        self.tableView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        title = Constans.Text.allFilesTitleLabel

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FullFileTableViewCell.self, forCellReuseIdentifier: fileCellIndentifier)
    }

    internal override func updateData () {
        
        activityIndicator.startAnimating()
        
        serviceAPI.fetchFullDiskResponse(path,limit) { result in
            switch result {
            case .success(let response):
                print("All files: \(response._embedded?.items.count ?? 0)")
                
                var model : [Items] = []
                for item in response._embedded?.items ?? [] {
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
                self.filesData.saveData()
                
                self.tableView.reloadData()
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

extension ThirdViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filesData.connectContext().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let files = filesData.connectContext()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: fileCellIndentifier) as? FullFileTableViewCell
        
        cell?.configure(files)
        
        if files.type == "dir" {
            cell?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        } else {
            cell?.accessoryType = UITableViewCell.AccessoryType.none
        }
        cell?.accessoryView?.backgroundColor = .white
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = filesData.connectContext()[indexPath.row]
        if file.type == "dir" {
            let vc = ViewingСontentController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.path = file.path
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = PresentViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.file = file 
            self.present(vc, animated: true, completion: nil)
        }
    }
}

