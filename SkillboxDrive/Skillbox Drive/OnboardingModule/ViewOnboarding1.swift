//
//  ViewOnboarding.swift
//  Skillbox Drive
//
//  Created by Bandit on 18.01.2023.
//

import UIKit
//import UIOnboarding
//import Onboard


final class ViewOnboarding1: UIViewController {
    
    private var section = 0
//    private var sectio = UIPageViewController()
    
    private lazy var imageOnbording: UIImageView = {
        let image = UIImageView(frame: .zero)
        return image
    }()
    
    private lazy var textOnbording: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Constans.Fonts.graphik17
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var imageOn: UIImageView = {
        let image = UIImageView(frame: .zero)
        return image
    }()
    
    private lazy var buttonNext: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 10
        button.backgroundColor = Constans.Color.colorButton
        button.setTitle(Constans.Text.onbordingButtonNext, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Constans.Fonts.graphik17
        button.addTarget(self, action: #selector(input), for: .touchUpInside)
        return button
        }()
    
    @objc private func input(_ sender: UIButton){
        section += 1
        getOnbording()
    }
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(imageOnbording)
        self.view.addSubview(textOnbording)
        self.view.addSubview(imageOn)
        self.view.addSubview(buttonNext)
        
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

        imageOn.translatesAutoresizingMaskIntoConstraints = false
        imageOn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageOn.widthAnchor.constraint(equalToConstant: 45).isActive = true
        imageOn.heightAnchor.constraint(equalToConstant: 9).isActive = true
        imageOn.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -183).isActive = true

        buttonNext.translatesAutoresizingMaskIntoConstraints = false
        buttonNext.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 27).isActive = true
        buttonNext.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -27).isActive = true
        buttonNext.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -92).isActive = true
        buttonNext.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        getOnbording()
    }
    
    private func getOnbording() {
        if section == 0 {
//            imageOnbording.image = Constans.Image.imageOnbording
            textOnbording.text = Constans.Text.onbordingFirstLabel
//            imageOn.image = Constans.Image.imageOn
        } else if section == 1 {
//            imageOnbording.image = Constans.Image.imageOnbording2
            textOnbording.text = Constans.Text.onbordingSecondLabel
//            imageOn.image = Constans.Image.imageOn2
        } else if section == 2 {
//            imageOnbording.image = Constans.Image.imageOnbording3
            textOnbording.text = Constans.Text.onbordingThirdLabel
//            imageOn.image = Constans.Image.imageOn3
        } else if section == 3 {
            section = 0
            let vc = ViewEntrance()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
