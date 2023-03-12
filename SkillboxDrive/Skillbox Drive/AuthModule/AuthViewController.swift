//
//  AuthViewController.swift
//  Skillbox Drive
//
//  Created by Bandit on 19.01.2023.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {
    
    private let serviceAPI = APIAuthorize()
    
    // MARK: - Button
    private lazy var buttonBack : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: UIControl.State.normal)
        button.tintColor = .gray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonBackView), for: .touchUpInside)
        return button
    }()
    
    @objc func buttonBackView () {
        let vc = ViewEntrance()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    
    private lazy var webView: WKWebView = {
        let view = WKWebView(frame: .zero)
        view.backgroundColor = .systemBackground
        return view
    }()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        view.addSubview(webView)
        view.addSubview(buttonBack)
        
        let margins = view.safeAreaLayoutGuide
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        buttonBack.widthAnchor.constraint(equalToConstant: 30).isActive = true
        buttonBack.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonBack.topAnchor.constraint(equalTo: margins.topAnchor, constant: 25).isActive = true
        buttonBack.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 25).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let request = serviceAPI.request else { return }
        webView.load(request)
        webView.navigationDelegate = self
    }
    
}

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == "skillboxdrive" {
            decisionHandler(.allow)
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }

            let token = components.queryItems?.first(where: { $0.name == "access_token"})?.value
            
            if let token = token {
                UserDefaults.standard.set(token, forKey: KeysUserDefaults.tokenUser)
            }
            dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: KeysUserDefaults.userIsLogged)
        } else {
            decisionHandler(.allow)
        }
    }
}
