//
//  PresentViewController.swift
//  Skillbox Drive
//
//  Created by Bandit on 08.02.2023.
//

import UIKit
import PDFKit
import WebKit
import AVFoundation
import CoreData

class PresentViewController: UIViewController{
    
    // MARK: - Model
    
    private var filesData: ResponsePresenter?
    var file: Items?
    
    private var publicURL = ""
    private var urlDownloadFile = ""
    
    private let serviceAPI = APIPresenter()
    
    
    // MARK: -
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.frame = UIScreen.main.bounds
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        imageView.contentMode = .scaleAspectFill
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        imageView.addGestureRecognizer(tap)
    }

    @objc private func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        imageView.contentMode = .scaleAspectFit
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tap)
    }
    
    private lazy var pdfView: PDFView = {
        let view = PDFView(frame: .zero)
        view.displayMode = .singlePageContinuous
        view.autoScales = true
        view.displayDirection = .vertical
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var webView: WKWebView = {
        let view = WKWebView(frame: .zero)
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Constans.Fonts.graphik15
        label.text = Constans.Text.lastLabelTextLabel
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: - Indicator
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .gray
        return view
    }()
    
    // MARK: - Lebel
    
    private lazy var labelNameFile: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Constans.Fonts.graphik17
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var labelDateFile: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Constans.Fonts.graphik13
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Button
    private lazy var buttonBack : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: UIControl.State.normal)
        button.tintColor = .gray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonBackView), for: .touchUpInside)
        return button
    }()
    
    @objc private func buttonBackView () {
        self.dismiss(animated: true)
    }
    
    private lazy var buttonEdit : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: UIControl.State.normal)
        button.tintColor = .gray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonEditView), for: .touchUpInside)
        return button
    }()
    
    @objc private func buttonEditView () {
        let vc = EditViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.file = file
//        vc.from = file?.path ?? "disk:/"
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - ToolBar
    
    private lazy var buttonShare : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: UIControl.State.normal)
        button.tintColor = .gray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonShareAlert), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonDelete : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: UIControl.State.normal)
        button.tintColor = .gray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonDeleteAlert), for: .touchUpInside)
        return button
    }()
    
    @objc private func buttonShareAlert () {
        let alert = UIAlertController(title: Constans.Text.lastButtonAlertShareImageTitle, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constans.Text.lastButtonAlertButtonTextFile, style: .default, handler: { action in
            
            self.presentShareSheetFile()
            
        }))
        alert.addAction(UIAlertAction(title: Constans.Text.lastButtonAlertButtonTextLink, style: .default, handler: { action in
            
            self.activityIndicator.startAnimating()
            self.serviceAPI.fetchLine(self.file?.path ?? "disk:/") { result in
                    switch result {
                    case .success(let response):
                        print(response)
                        self.updateData(self.file?.path ?? "disk:/")
                        sleep(1)
                        DispatchQueue.main.async {
                            self.publicURL = self.filesData?.public_url ?? "Error"
                            self.presentShareSheetLink()
                            self.activityIndicator.stopAnimating()
                        }
                    case .failure(let error):
                        UtilsShowAlert.showAlertErrorNoInternet(viewcontroller: self)
                        print("Error loading recommended podcasts: \(error.localizedDescription)")
                        self.activityIndicator.stopAnimating()
                    }
                }
        }))
        alert.addAction(UIAlertAction(title: Constans.Text.lastButtonAlertButtonTextCancel, style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func buttonDeleteAlert () {
        let alert = UIAlertController(title: Constans.Text.lastButton2AlertDeleteImageTitle, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constans.Text.lastButton2AlertButtonTextDelete, style: .destructive, handler: { action in
            
            self.activityIndicator.startAnimating()
            self.serviceAPI.fetchDelite(self.file?.path ?? "disk:/") { result in
                    switch result {
                    case .success(let response):
                        print(response)
                        self.activityIndicator.stopAnimating()
                        self.dismiss(animated: true)
                    case .failure(let error):
                        UtilsShowAlert.showAlertErrorNoInternet(viewcontroller: self)
                        print("Error loading recommended podcasts: \(error.localizedDescription)")
                        self.activityIndicator.stopAnimating()
                    }
                }
        }))
        alert.addAction(UIAlertAction(title: Constans.Text.lastButton2AlertButtonTextCancel, style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - ShareSheet
    private func presentShareSheetFile () {
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = documentsUrl.appendingPathComponent(file?.name ?? "file")
        
        let shareShetVC = UIActivityViewController(activityItems: [destinationFileUrl], applicationActivities: nil)
        present(shareShetVC,animated: true)
    }
    
    private func presentShareSheetLink () {
        guard let url = URL(string: "\(publicURL)") else { return }
        let shareShetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(shareShetVC,animated: true)
    }
    
    // MARK: - LoadView
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(imageView)
        self.view.addSubview(pdfView)
        self.view.addSubview(webView)
        self.view.addSubview(activityIndicator)
        
        self.view.addSubview(labelNameFile)
        self.view.addSubview(labelDateFile)
        
        self.view.addSubview(buttonBack)
        self.view.addSubview(buttonEdit)
        self.view.addSubview(buttonShare)
        self.view.addSubview(buttonDelete)
        
        self.view.addSubview(label)
        
        let margins = view.safeAreaLayoutGuide

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        imageView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true

        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        pdfView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 0).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        webView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        
        labelNameFile.translatesAutoresizingMaskIntoConstraints = false
        labelNameFile.heightAnchor.constraint(equalToConstant: 20).isActive = true
        labelNameFile.topAnchor.constraint(equalTo: margins.topAnchor, constant: 25).isActive = true
        labelNameFile.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 60).isActive = true
        labelNameFile.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -60).isActive = true
        
        labelDateFile.translatesAutoresizingMaskIntoConstraints = false
        labelDateFile.heightAnchor.constraint(equalToConstant: 15).isActive = true
        labelDateFile.topAnchor.constraint(equalTo: margins.topAnchor, constant: 50).isActive = true
        labelDateFile.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 60).isActive = true
        labelDateFile.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -60).isActive = true
        
        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        buttonBack.widthAnchor.constraint(equalToConstant: 30).isActive = true
        buttonBack.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonBack.topAnchor.constraint(equalTo: margins.topAnchor, constant: 25).isActive = true
        buttonBack.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 25).isActive = true
        
        buttonEdit.translatesAutoresizingMaskIntoConstraints = false
        buttonEdit.widthAnchor.constraint(equalToConstant: 30).isActive = true
        buttonEdit.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonEdit.topAnchor.constraint(equalTo: margins.topAnchor, constant: 25).isActive = true
        buttonEdit.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -25).isActive = true

        buttonShare.translatesAutoresizingMaskIntoConstraints = false
        buttonShare.widthAnchor.constraint(equalToConstant: 30).isActive = true
        buttonShare.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonShare.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 57).isActive = true
        buttonShare.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -37).isActive = true
        
        buttonDelete.translatesAutoresizingMaskIntoConstraints = false
        buttonDelete.widthAnchor.constraint(equalToConstant: 30).isActive = true
        buttonDelete.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonDelete.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -57).isActive = true
        buttonDelete.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -37).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        
        self.imageView.isHidden = true
        self.pdfView.isHidden = true
        self.webView.isHidden = true
        self.label.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        self.labelNameFile.text = self.file?.name
        self.labelDateFile.text = self.file?.created?.dateFormater()
        
        setTypeView(file?.mime_type ?? "Error")
    }
        
    private func setTypeView (_ type: String) {
        activityIndicator.startAnimating()
        switch type {
        case _ where type.contains("image"):
            self.imageView.isHidden = false
        case _ where type.contains("application/vnd"):
            self.webView.isHidden = false
        case _ where type.contains("application/pdf"):
            self.pdfView.isHidden = false
        default:
            self.label.isHidden = false
            break
        }
        downloadFileFoLine()
    }
    
    private func downloadFileFoLine () {
        
        serviceAPI.fetchURLFile(file?.path ?? "disk:/") { result in
            switch result {
            case .success(let response):
                self.urlDownloadFile = response.href ?? ""
                self.downloadFilePhone()
            case .failure(let error):
                self.webViewInte(self.file?.mime_type ?? "Error")
                UtilsShowAlert.showAlertErrorNoInternet(viewcontroller: self)
                print("Error loading recommended podcasts: \(error.localizedDescription)")
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func downloadFilePhone () {
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = documentsUrl.appendingPathComponent(file?.name ?? "file")
        
        guard let fileURL = URL(string: urlDownloadFile) else { return }
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fileURL)

        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    DispatchQueue.main.async {
                        self.webViewInte(self.file?.mime_type ?? "Error")
                    }
                } catch (let writeError) {
                    DispatchQueue.main.async {
                        self.webViewInte(self.file?.mime_type ?? "Error")
                    }
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            } else {
                self.activityIndicator.stopAnimating()
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription as Any)
            }
        }
        task.resume()
    }
    
    // extensin
    func getImageFoImageView(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func webViewInte (_ type: String) {
        switch type {
        case _ where type.contains("image"):
            DispatchQueue.main.async {
                if let image = self.getImageFoImageView(named: self.file?.name ?? "file") {
                    self.imageView.image = image
                }
                self.activityIndicator.stopAnimating()
            }
        case _ where type.contains("application/vnd"):
            DispatchQueue.main.async {
                let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let destinationFileUrl = documentsUrl.appendingPathComponent(self.file?.name ?? "file")
                
                self.webView.load(URLRequest(url: destinationFileUrl))
                self.activityIndicator.stopAnimating()
            }
        case _ where type.contains("application/pdf"):
            DispatchQueue.main.async {
                let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let destinationFileUrl = documentsUrl.appendingPathComponent(self.file?.name ?? "file")
                if let pdfDocument = PDFDocument(url: destinationFileUrl) {
                    self.pdfView.document = pdfDocument
                }
                self.activityIndicator.stopAnimating()
            }
        default:
            UtilsShowAlert.showAlertErrorNoInternet(viewcontroller: self)
            self.activityIndicator.stopAnimating()
            break
        }
    }
    
    private func updateData (_ path: String) {
        self.activityIndicator.startAnimating()
        serviceAPI.fetchPresenter(path) { result in
                switch result {
                case .success(let response):
                    self.filesData = response
                    self.activityIndicator.stopAnimating()
                case .failure(let error):
                    UtilsShowAlert.showAlertErrorNoInternet(viewcontroller: self)
                    print("Error loading recommended podcasts: \(error.localizedDescription)")
                    self.activityIndicator.stopAnimating()
                }
            }
    }
}

extension PresentViewController : EditViewControllerDelegate {
    func transmissionFile(file: Items?) {
        self.file = file
        self.labelNameFile.text = self.file?.name
        self.labelDateFile.text = self.file?.created?.dateFormater()
        setTypeView(file?.mime_type ?? "Error")
    }
}

