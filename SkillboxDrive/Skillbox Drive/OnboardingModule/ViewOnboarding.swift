//
//  ViewOnboarding.swift
//  Skillbox Drive
//
//  Created by Bandit on 15.02.2023.
//

import UIKit

class ViewOnboarding: UIViewController {
    
    let imageView = UIImageView()
    let subtitleLabel = UILabel()
    
    init(imageName: String, subtitleText: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: imageName)
        subtitleLabel.text = subtitleText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        style()
        layout()
    }
}

extension ViewOnboarding {
    
    func style() {
        
        imageView.contentMode = .scaleAspectFit
        
        subtitleLabel.font = Constans.Fonts.graphik17
        subtitleLabel.textColor = .black
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 2
        subtitleLabel.lineBreakMode = .byWordWrapping
    }
        
    func layout() {
        view.addSubview(imageView)
        view.addSubview(subtitleLabel)
        
        let margins = view.safeAreaLayoutGuide
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 168).isActive = true
        imageView.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -67).isActive = true

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 65).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -65).isActive = true
        subtitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -260).isActive = true
    }
}

