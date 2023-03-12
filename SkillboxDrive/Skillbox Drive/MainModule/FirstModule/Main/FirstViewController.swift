//
//  FirstViewController.swift
//  Skillbox Drive
//
//  Created by Bandit on 20.01.2023.
//

import UIKit
import Charts
import WebKit

class FirstViewController: UIViewController {
    
    private var filesData: DiskDataResponse?
    private let serviceAPI = APISizeDisk()
    
    private lazy var pieView: PieChartView = {
        let view = PieChartView()
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "        \((self.filesData?.used_space ?? 0).formatterForSizeValueFile()) - \(Constans.Text.profileLabelOccupied)"
        label.font = Constans.Fonts.graphik15
        label.textColor = NSUIColor(hex: 0xf1afaa)
        let image: UIImage = UIImage(systemName: "circle.fill")!
        var bgImage: UIImageView?
        bgImage = UIImageView(image: image)
        bgImage!.frame = CGRectMake(0,0,21,21)
        bgImage?.tintColor = NSUIColor(hex: 0xf1afaa)
        label.addSubview(bgImage!)
        return label
    }()
    
    private lazy var textLabelTwo: UILabel = {
        let label = UILabel()
        label.text = "        \(((filesData?.total_space ?? 0) - (filesData?.used_space ?? 0)).formatterForSizeValueFile()) - \(Constans.Text.profileLabelFree)"
        label.font = Constans.Fonts.graphik15
        label.textColor = NSUIColor(hex: 0x9e9e9e)

        let image: UIImage = UIImage(systemName: "circle.fill")!
        var bgImage: UIImageView?
        bgImage = UIImageView(image: image)
        bgImage!.frame = CGRectMake(0,0,21,21)
        bgImage?.tintColor = NSUIColor(hex: 0x9e9e9e)
        label.addSubview(bgImage!)
        return label
    }()
    
    private lazy var contentsView: UIView = {
       let view = UIView(frame: .zero)
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        
        view.addSubview(labelImage)
        view.addSubview(buttonNextView)
       return view
   }()
    
    private lazy var buttonNextView : UIButton = {
        let button = UIButton()
        button.setTitle(Constans.Text.profileButtonText, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = Constans.Fonts.graphik15
        button.tintColor = .gray
        button.layer.cornerRadius = 10
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(nextView), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @objc private func nextView () {
        let vc = PublishedFilesViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .gray
        return indicator
    }()
    
    override func loadView() {
        super.loadView()
        view.addSubview(pieView)
        view.addSubview(textLabel)
        view.addSubview(textLabelTwo)
        view.addSubview(contentsView)
        view.addSubview(activityIndicator)
        
        let margins = view.safeAreaLayoutGuide

        pieView.translatesAutoresizingMaskIntoConstraints = false
        pieView.heightAnchor.constraint(equalToConstant: 280).isActive = true
        pieView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 35).isActive = true
        pieView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 32).isActive = true
        pieView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -32).isActive = true

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        textLabel.topAnchor.constraint(equalTo: pieView.bottomAnchor, constant: 15).isActive = true
        textLabel.leftAnchor.constraint(equalTo: pieView.leftAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: pieView.trailingAnchor).isActive = true

        textLabelTwo.translatesAutoresizingMaskIntoConstraints = false
        textLabelTwo.heightAnchor.constraint(equalToConstant: 20).isActive = true
        textLabelTwo.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 15).isActive = true
        textLabelTwo.leftAnchor.constraint(equalTo: pieView.leftAnchor).isActive = true
        textLabelTwo.trailingAnchor.constraint(equalTo: pieView.trailingAnchor).isActive = true
        
        contentsView.translatesAutoresizingMaskIntoConstraints = false
        contentsView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        contentsView.topAnchor.constraint(equalTo: textLabelTwo.bottomAnchor, constant: 20).isActive = true
        contentsView.leftAnchor.constraint(equalTo: pieView.leftAnchor).isActive = true
        contentsView.trailingAnchor.constraint(equalTo: pieView.trailingAnchor).isActive = true
        
        buttonNextView.translatesAutoresizingMaskIntoConstraints = false
        buttonNextView.leftAnchor.constraint(equalTo: contentsView.leftAnchor, constant: 10).isActive = true
        buttonNextView.topAnchor.constraint(equalTo: contentsView.topAnchor).isActive = true
        buttonNextView.rightAnchor.constraint(equalTo: contentsView.rightAnchor).isActive = true
        buttonNextView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor).isActive = true
        
        labelImage.translatesAutoresizingMaskIntoConstraints = false
        labelImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        labelImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        labelImage.centerYAnchor.constraint(equalTo: contentsView.centerYAnchor).isActive = true
        labelImage.rightAnchor.constraint(equalTo: contentsView.rightAnchor, constant: -10).isActive = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.pieView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.pieView.centerYAnchor).isActive = true

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        title = Constans.Text.profileTitleLabel
        
        setupTabBarButton()
        setupPieChart()
        
    }
    
    
    // MARK: - ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateData()
    }
    
    private func setupTabBarButton () {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(tabBarButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }

    @objc private func tabBarButtonPressed() {
        
        let alert = UIAlertController(title: Constans.Text.profileTitleLabel, message: Constans.Text.profileAlertSubText, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constans.Text.profileAlertButtonTextExit, style: .destructive, handler: { action in
            let alert = UIAlertController(title: Constans.Text.profileAlert2TitleText, message: Constans.Text.profileAlert2SubText, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constans.Text.profileAlert2ButtonTextNo, style: .destructive))
            alert.addAction(UIAlertAction(title: Constans.Text.profileAlert2ButtonTextYes, style: .cancel, handler: { action in
                
                UserDefaults.standard.removeObject(forKey: KeysUserDefaults.userIsLogged)
                UserDefaults.standard.removeObject(forKey: KeysUserDefaults.tokenUser)
                
                CoreDataManager.shared.deleteAllData("PublishedFile")
                CoreDataManager.shared.deleteAllData("LastFiles")
                CoreDataManager.shared.deleteAllData("AllFiles")
                
                let fileManager = FileManager.default
                do {
                    let documentDirectoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let fileURLs = try fileManager.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                    for url in fileURLs {
                        try fileManager.removeItem(at: url)
                    }
                } catch {
                    print(error)
                }
                
                WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()){ records in
                    records.forEach { record in
                        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                    }
                }
                
                let vc = ViewEntrance()
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: Constans.Text.profileAlertButtonTextCancel, style: .cancel))
        self.present(alert, animated: true, completion: nil)
       }


    private func setupPieChart () {
        pieView.rotationAngle = 0
        pieView.drawEntryLabelsEnabled = false //Show block text
        pieView.drawCenterTextEnabled = true //Show center text
        pieView.holeRadiusPercent = 0.550

        let myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19) ]
        let myAttrString = NSAttributedString(string: "0 \(Constans.Text.profileLabelUnitBt)", attributes: myAttribute)
        pieView.centerAttributedText = myAttrString

        pieView.legend.enabled = false

        var entries: [PieChartDataEntry] = Array()
        entries.append(PieChartDataEntry(value: (filesData?.used_space ?? 50).formatterForSizeCharts(), label: Constans.Text.profileLabelOccupied))
        entries.append(PieChartDataEntry(value: ((filesData?.total_space ?? 50) - (filesData?.used_space ?? 0)).formatterForSizeCharts(), label: Constans.Text.profileLabelFree))

        let dataSet = PieChartDataSet(entries: entries, label: "")

        let c1 = NSUIColor(hex: 0xf1afaa)
        let c2 = NSUIColor(hex: 0x9e9e9e)

        dataSet.colors = [c1, c2]
        dataSet.drawValuesEnabled = false

        pieView.data = PieChartData(dataSet: dataSet)
    }

    private func updateData () {
        activityIndicator.startAnimating()
        
        serviceAPI.fetchSizeDisk() { result in
            switch result {
            case .success(let response):
                self.filesData = response
                self.setupPieChart()
                self.textLabel.text = "        \((self.filesData?.used_space ?? 0).formatterForSizeValueFile()) - \(Constans.Text.profileLabelOccupied)"
                self.textLabelTwo.text = "        \(((self.filesData?.total_space ?? 0) - (self.filesData?.used_space ?? 0)).formatterForSizeValueFile()) - \(Constans.Text.profileLabelFree)"
                let myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19) ]
                let myAttrString = NSAttributedString(string: "\((self.filesData?.total_space ?? 0).formatterForSizeValueFile())", attributes: myAttribute)
                self.pieView.centerAttributedText = myAttrString
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                UtilsShowAlert.showAlertErrorNoInternet(viewcontroller: self)
                print("Error loading recommended podcasts: \(error.localizedDescription)")
                self.activityIndicator.stopAnimating()
            }
        }
    }
}


