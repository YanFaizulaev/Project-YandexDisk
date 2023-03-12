//
//  PublishedFilesViewController.swift
//  Skillbox Drive
//
//  Created by Bandit on 25.01.2023.
//

import UIKit

final class PublishedFilesViewController: TableViewControllerDefault {
    
    private var filesData = PublishedFileClass()
    
    // MARK: - Presenter
    
    private var presenter: PublishedFilesPresenter!
    private let serviceAPI = APIPublishedNetworkService()
    
    // MARK: - Onbording
    private lazy var imageOnbording: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.image = Constans.Image.imageOnbording4
        return image
    }()
    
    private lazy var textOnbording: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Constans.Fonts.graphik17
        label.text = Constans.Text.profileOnbordingLabel
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var buttonUpdate: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 10
        button.backgroundColor = Constans.Color.colorButtonUpdate
        button.setTitle(Constans.Text.profileOnbordingButtonText, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = Constans.Fonts.graphik17
        button.addTarget(self, action: #selector(update), for: .touchUpInside)
        return button
        }()
    
    @objc private func update (_ sender: UIButton){
        updateData()
    }

    private let upDateCellIndentifier = "UpDateTableViewCell"

    // MARK: - LoadView
    override func loadView() {
        super.loadView()

        self.view.addSubview(imageOnbording)
        self.view.addSubview(textOnbording)
        self.view.addSubview(buttonUpdate)
        
        let margins = view.safeAreaLayoutGuide
        
        imageOnbording.translatesAutoresizingMaskIntoConstraints = false
        imageOnbording.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageOnbording.heightAnchor.constraint(equalToConstant: 168).isActive = true
        imageOnbording.bottomAnchor.constraint(equalTo: textOnbording.topAnchor, constant: -67).isActive = true
        
        textOnbording.translatesAutoresizingMaskIntoConstraints = false
        textOnbording.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 65).isActive = true
        textOnbording.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -65).isActive = true
        textOnbording.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textOnbording.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -260).isActive = true
        
        buttonUpdate.translatesAutoresizingMaskIntoConstraints = false
        buttonUpdate.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 27).isActive = true
        buttonUpdate.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -27).isActive = true
        buttonUpdate.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20).isActive = true
        buttonUpdate.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.imageOnbording.isHidden = true
        self.textOnbording.isHidden = true
        self.buttonUpdate.isHidden = true
        self.tableView.isHidden = true
        
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        title = Constans.Text.profileButtonText

        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .gray
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UpDateTableViewCell.self, forCellReuseIdentifier: upDateCellIndentifier)
        
    }
    
    // MARK: - Functions
    internal override func updateData () {
        activityIndicator.startAnimating()

        serviceAPI.fetchPublishedFiles(limit) { result in
            switch result {
            case .success(let response):
                print("Published files: \(response.items.count)")
        
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
                self.imageOnbording.isHidden = false
                self.textOnbording.isHidden = false
                self.buttonUpdate.isHidden = false
            } else {
                self.tableView.isHidden = false
            }
        }
    }
}

// MARK: - Table View Data Source
extension PublishedFilesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filesData.connectContext().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let files = filesData.connectContext()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: upDateCellIndentifier) as? UpDateTableViewCell
        
        cell?.configure(files)
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let file = filesData.fetchedResultController.object(at: indexPath)

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

// MARK: - Table View Cell Delegate Protocol
protocol PublishedTableViewCellDelegate: AnyObject {
    func presentAlertTableViewCell(_ tableViewCell: UpDateTableViewCell, subscribeButtonTappedFor nameFile: String, path: String)
}

// MARK: - Table View Cell Delegate
extension PublishedFilesViewController : PublishedTableViewCellDelegate {
    func presentAlertTableViewCell(_ tableViewCell: UpDateTableViewCell, subscribeButtonTappedFor nameFile: String, path: String) {
        
        let alert = UIAlertController(title: "\(nameFile)", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constans.Text.profileButtonCellText, style: .destructive, handler: { action in
            
            self.activityIndicator.startAnimating()
            self.serviceAPI.fetchDeleteActiveLink(path) { result in
                switch result {
                case .success(let response):
                    print(response)
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.updateData()
                case .failure(let error):
                    UtilsShowAlert.showAlertErrorNoInternet(viewcontroller: self)
                    print("Error loading recommended podcasts: \(error.localizedDescription)")
                    self.activityIndicator.stopAnimating()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: Constans.Text.profileButtonCellText2, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Published Files Output
extension PublishedFilesViewController: PublishedFilesProtocolOutput {
    
    func success() {
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
    }
    
    func failure(error: Error) {
        self.activityIndicator.stopAnimating()
        UtilsShowAlert.showAlertErrorNoInternet(viewcontroller: self)
        print(error.localizedDescription)
    }

}

