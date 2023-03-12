//
//  EditViewController.swift
//  Skillbox Drive
//
//  Created by Bandit on 09.02.2023.
//

import UIKit

protocol EditViewControllerDelegate: AnyObject {
    func transmissionFile (file: Items?)
}

class EditViewController: UIViewController {
    
    weak var delegate: EditViewControllerDelegate?
    var file: Items?
    
    private let serviceAPI = APIEdit()
    
    // MARK: - Indicator
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .gray
        return view
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

    private lazy var buttonDone : UIButton = {
        let button = UIButton()
        button.setTitle(Constans.Text.lastButton3ButtonTextDone, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = Constans.Fonts.graphik13
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonDoneView), for: .touchUpInside)
        return button
    }()

    @objc private func buttonDoneView () {
        
        if name == originName {
            self.dismiss(animated: true)
        }
        
        name = textField.text ?? "Default"
        self.path = pathEnd + name + doc
        
        self.activityIndicator.startAnimating()
        self.serviceAPI.fetchEdit(from: file?.path ?? "disk:/", path: self.path) { result in
            switch result {
            case .success(let response):
                print(response)
    
                do {
                    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                    let documentDirectory = URL(fileURLWithPath: path)
                    let originPath = documentDirectory.appendingPathComponent(self.originName + self.doc)
                    let destinationPath = documentDirectory.appendingPathComponent(self.name + self.doc)
                    try FileManager.default.moveItem(at: originPath, to: destinationPath)
                } catch {
                    print(error)
                }
                
                self.file?.name = self.name + self.doc
                self.file?.path = self.path
                self.delegate?.transmissionFile(file: self.file)
                self.dismiss(animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                UtilsShowAlert.showAlertErrorNoInternet(viewcontroller: self)
                print("Error loading recommended podcasts: \(error.localizedDescription)")
                self.activityIndicator.stopAnimating()
            }
        }
    }

    // MARK: - Label
    private lazy var labelTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Constans.Fonts.graphik17
        label.text = Constans.Text.lastButton3TitleRename
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    // MARK: - ContentsView
    private lazy var contentsView: UIView = {
       let view = UIView(frame: .zero)
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.addSubview(labelImage)
        view.addSubview(textField)
        view.addSubview(buttonEditTextField)
       return view
   }()

    private lazy var labelImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.font = Constans.Fonts.graphik17
        textField.textColor = .black
        textField.placeholder = Constans.Text.lastTextFieldPlaceholder
        
        //        textField.clearButtonMode = .always
        //        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: path)
        //        if let commaIndex = path.firstIndex(of: ".") {
        //            attributedString.addAttribute(.foregroundColor,
        //                                          value: UIColor.systemBlue,
        //                                          range: NSRange(path.startIndex ..< commaIndex, in: path)
        //            )
        //            attributedString.addAttribute(.foregroundColor,
        //                                          value: UIColor.systemRed,
        //                                          range: NSRange(commaIndex ..< path.endIndex, in: path)
        //            )
        //        }
        //        textField.attributedText = attributedString
        textField.addTarget(self,action: #selector(self.textFieldFilter), for: .editingChanged)
        return textField
    }()
    
    @objc private func textFieldFilter(_ textField: UITextField) {
        if textField.text?.count == 0 {
            buttonDone.isEnabled = false
            buttonDone.setTitleColor(.red, for: .normal)
        } else {
            buttonDone.isEnabled = true
            buttonDone.setTitleColor(.blue, for: .normal)
        }
    }

    
    private lazy var buttonEditTextField : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "multiply.circle"), for: UIControl.State.normal)
        button.tintColor = .gray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonEditText), for: .touchUpInside)
        return button
    }()

    @objc private func buttonEditText () {
        textField.text = ""
        buttonDone.isEnabled = false
        buttonDone.setTitleColor(.red, for: .normal)
    }

    override func loadView() {
        super.loadView()

        self.view.addSubview(buttonBack)
        self.view.addSubview(buttonDone)
        self.view.addSubview(labelTitle)

        self.view.addSubview(contentsView)
        self.view.addSubview(activityIndicator)

        let margins = view.safeAreaLayoutGuide

        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        buttonBack.widthAnchor.constraint(equalToConstant: 30).isActive = true
        buttonBack.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonBack.topAnchor.constraint(equalTo: margins.topAnchor, constant: 25).isActive = true
        buttonBack.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 25).isActive = true

        buttonDone.translatesAutoresizingMaskIntoConstraints = false
        buttonDone.widthAnchor.constraint(equalToConstant: 55).isActive = true
        buttonDone.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonDone.topAnchor.constraint(equalTo: margins.topAnchor, constant: 25).isActive = true
        buttonDone.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -25).isActive = true

        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        labelTitle.topAnchor.constraint(equalTo: margins.topAnchor, constant: 30).isActive = true
        labelTitle.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 80).isActive = true
        labelTitle.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -80).isActive = true

        contentsView.translatesAutoresizingMaskIntoConstraints = false
        contentsView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        contentsView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 20).isActive = true
        contentsView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 105).isActive = true
        contentsView.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -20).isActive = true

        labelImage.translatesAutoresizingMaskIntoConstraints = false
        labelImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        labelImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        labelImage.centerYAnchor.constraint(equalTo: contentsView.centerYAnchor).isActive = true
        labelImage.leftAnchor.constraint(equalTo: contentsView.leftAnchor, constant: 5).isActive = true


        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftAnchor.constraint(equalTo: labelImage.rightAnchor, constant: 5).isActive = true
        textField.rightAnchor.constraint(equalTo: buttonEditTextField.leftAnchor, constant: -5).isActive = true
        textField.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 5).isActive = true
        textField.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor, constant: -5).isActive = true

        buttonEditTextField.translatesAutoresizingMaskIntoConstraints = false
        buttonEditTextField.widthAnchor.constraint(equalToConstant: 20).isActive = true
        buttonEditTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        buttonEditTextField.centerYAnchor.constraint(equalTo: contentsView.centerYAnchor).isActive = true
        buttonEditTextField.rightAnchor.constraint(equalTo: contentsView.rightAnchor, constant: -10).isActive = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setNameAndPath(file?.path ?? "disk:/")
        textField.text = name
        loadImage(stringUrl: file?.preview ?? "") { image in
            if self.file?.type == "dir" {
                self.labelImage.image = UIImage(named: "IconFile")
            } else {
                self.labelImage.image = image
            }
        }
    }
    
    private var pathEnd = ""
    private var name = ""
    private var originName = ""
    private var doc = ""
    private var path = ""

    private func setNameAndPath(_ path: String) {
        
        var paths = ""
        var nameDoc = ""
        
        if let range = path.range(of: "/", options: .backwards) {
            nameDoc = String(path[range.upperBound...])
        }
        if let lastIndex = nameDoc.lastIndex(of: ".") {
            name = String(nameDoc[..<lastIndex])
            originName = String(nameDoc[..<lastIndex])
        }
        
        if let lastIndex = path.lastIndex(of: ".") {
            paths = String(path[..<lastIndex])
            doc = String(path[lastIndex...])
        }
        
        if let lastIndex = paths.lastIndex(of: "/") {
            pathEnd = String(paths[...lastIndex])
        }
    }
}

extension EditViewController {
    func loadImage(stringUrl: String, completion: @escaping ((UIImage?) -> Void)) {
        let token = UserDefaults.standard.tokenUser
        guard let url = URL(string: stringUrl) else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }
        task.resume()
    }
}
