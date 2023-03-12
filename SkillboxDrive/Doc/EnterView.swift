//
//  EnterView.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 18.09.2022.
//

import UIKit

class EnterView: UIView {
    
   private lazy var margins = safeAreaLayoutGuide

    var onButtonTap: (() -> Void)?
    
// MARK: - Views

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Vector")
        return imageView
    }()
    
    private let skillboxImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "Skillbox Drive")
       return imageView
    }()
    
    private lazy var labelStack: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [logoImageView, skillboxImageView])
        stackView.spacing = 29
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let enterButton = UIButton.customButton(title: "Войти", backgroundColor: UIColor(named: "EnterButton") ?? .systemBlue, titleColor: .white, fontSize: 16, radius: 10)
    
    private func setupBehaviour() {
        enterButton.addTarget(self, action: #selector(onButtonTapHandler), for: .touchUpInside)
    }
    
//   MARK: - Constraints
    
    private lazy var commonConstraints: [NSLayoutConstraint] = {
        return [
            labelStack.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            enterButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 27),
            margins.trailingAnchor.constraint(equalTo: enterButton.trailingAnchor, constant: 27),
            enterButton.heightAnchor.constraint(equalToConstant: 50)
        ]
    }()
    
    private lazy var regularConstraints: [NSLayoutConstraint] = {
       return [
        labelStack.topAnchor.constraint(equalTo: margins.topAnchor, constant: 180),
        margins.bottomAnchor.constraint(equalTo: enterButton.bottomAnchor, constant: 92)
       ]
    }()
    
    private lazy var compactConstraints: [NSLayoutConstraint] = {
        return [
            labelStack.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40),
            margins.bottomAnchor.constraint(equalTo: enterButton.bottomAnchor, constant: 35)
        ]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupBehaviour()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

   
    private func setupView() {
        addSubview(labelStack)
        addSubview(enterButton)
        
        NSLayoutConstraint.activate(commonConstraints)
        configureView(for: traitCollection)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
            configureView(for: traitCollection)
        }
    }
    
    private func configureView(for traitCollection: UITraitCollection) {
        if traitCollection.verticalSizeClass == .compact {
            NSLayoutConstraint.deactivate(regularConstraints)
            NSLayoutConstraint.activate(compactConstraints)
        } else {
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(regularConstraints)
        }
    }
    
    @objc private func onButtonTapHandler() {
        onButtonTap?()
    }
    
}
